// ==UserScript==
// @name           E-Hentai Highlighter
// @namespace      http://userscripts.org/users/106844
// @description    Highlighter for E-Hentai (e-hentai.org/exhentai.org). Supports regular expressions.
// @include        http://e-hentai.org/*
// @include        https://e-hentai.org/*
// @include        http://g.e-hentai.org/*
// @include        https://g.e-hentai.org/*
// @include        http://exhentai.org/*
// @include        https://exhentai.org/*
// @grant          GM_getValue
// @grant          GM_setValue
// @version        0.5.11.3
// ==/UserScript==

// -------------------- DEFAULTS -------------------

var defaults = {
    defaultColor       : '#ec7e7e' ,
    exColor            : '#ed6464' ,
    highlighterEnabled : false     ,
    filterEnabled      : false     ,
    opacityEnabled     : false     ,
    opacity            : 0.1       ,
    showTags           : true      ,
    highlightTags      : true      ,
    reorderGalleries   : true      ,
    hideRatedGalleries : false     ,
    showHideOption     : true      ,
    smartForegrounds   : false     ,
	chronologicalOrder : false     ,
};

// -------------------- /DEFAULTS -------------------

var EHH = {
    
    init: function() {

        EHH.augmentJS();

        // settings

        EHH.settings = { };
        for (var key in defaults)
            EHH.settings[key] = Utils.load(key, defaults[key]);

        EHH.dontWalk     = false;
        EHH.onPanda      = document.URL.indexOf('e-hentai') == -1;
        EHH.defaultColor = EHH.settings[EHH.onPanda ? 'exColor' : 'defaultColor'];
        EHH.thumbnails   = document.querySelector('.itg .gl1t') !== null;
        EHH.gallery      = document.querySelector('#taglist')  !== null;

        // User data
        
        Utils.migrateSettings();
    
        EHH.keywords = Utils.load('keywords',[ ]);
        EHH.filters  = Utils.load('filters',[ ]);

        EHH.addMenuItems();
        EHH.updateMenu();

        // Colors

        var colors = 
            EHH.onPanda ? { toggle: 'lightblue', toggleHover: 'lightcyan', disable: 'lightgreen',
                            disableHover: 'springgreen', enable: 'salmon', enableHover: 'lightsalmon',
                            row1: '#363940', row2: '#4F535B' }
                        : { toggle: 'slateblue', toggleHover: 'skyblue', disable: 'forestgreen',
                            disableHover: 'mediumseagreen', enable: 'indianred', enableHover: 'darkred',
                            row1: '#F2F0E4', row2: '#EDEBDF' };

        var format = function(text) { return text.replace(/%(\w+)/g,function(x) { return colors[x.slice(1)]; }); };
            
        // Permanent style
        
        var style = document.createElement('style');
        style.innerHTML = format(
            // popup (general)
            '#e-HentaiPopup {' +
                'position: fixed; top: 0; right: 0; padding: 3px; border-radius: 0 !important;' +
                'border: 1px black solid; z-index: 10; margin: 0 !important; min-width: 0 !important; width: auto !important;' +
            '}' +
            '#e-HentaiPopup:not(:hover) *:not(:first-child) { display: none; }' +
            '#e-HentaiPopup * {' +
                'font-family: Verdana, Tahoma, Georgia, Dejavu, "Times New Roman", Serif;' +
                'font-size: 10px;' +
            '} #e-Header { text-align: center; position: relative; }' +
            '[mode="default"] [mode="settings"], [mode="settings"] [mode="default"] { display: none; }' +
            '#e-ToggleMode {' +
                'cursor: pointer; color: %toggle !important; font-weight: bold;' +
                'position: absolute; right: 5px; border-bottom: 1px dotted;' +
            '}' +
            '#e-ToggleMode:hover { color: %toggleHover !important; }' +
            '#e-HentaiPopup div[mode] { width: 350px; text-align: left; }' +
            // user menu
            '#hideRatedLabel { text-decoration: underline; cursor: pointer; display: none; }' +
            '#hideRatedLabel.visible { display: inline; }' +
            '#hideRatedLabel.active { color: red; font-weight: bold; }' +
            // popup (default view)
            '#e-HentaiPopup td:nth-child(2) { text-align: right; }' +
            '#e-HentaiPopup td:nth-child(2) a, #e-HentaiPopup tr:last-child a {' +
                'cursor: pointer; font-weight: bold; border-bottom: 1px dotted;' +
            '}' +
            '#e-HentaiPopup .e-Disable { color: %disable; }' +
            '#e-HentaiPopup .e-Disable:hover { color: %disableHover; }' +
            '#e-HentaiPopup .e-Enable { color: %enable; }' +
            '#e-HentaiPopup .e-Enable:hover { color: %enableHover; }' +
            '#e-HentaiPopup tr:last-child a:hover { color: black; }' +
            '#e-HentaiPopup td > span { margin-right: 5px; float: right; }' +
            '#e-HentaiPopup table { width: 100%; }' +
            '#e-HentaiPopup textarea { width: 100%; height: 200px; box-sizing: border-box; -moz-box-sizing: border-box; }' +
            // popup (settings view)
            '#e-HentaiPopup label { display: block; padding: 2px; }' +
            '#e-HentaiPopup input[type="checkbox"] { margin: 0 5px 0 0; float: left; }' +
            '[name="slider"]:not([visible="true"]), [name="slider"]:not([visible="true"]) + span { display: none; }' +
            '[name="slider"] { margin-left: 20px; width: 250px; }' +
            '[name="slider"] + span { position: relative; bottom: 7px; }' +
            '#e-HentaiPopup [mode="settings"] { padding: 10px; box-sizing: border-box; -moz-box-sizing: border-box; }' +
            '#e-Buttons { text-align: center; padding-top: 20px; }' +
            '.e-Button {' +
                'min-width: 100px; height: 25px; line-height: 25px; text-align: center; color: white;' +
                'background: black; display: inline-block; cursor: pointer; margin-right: 10px;' +
            '}' +
            '.e-Button:hover { text-decoration: underline; }' +
            '.e-Button + input { display: none; }' +
            '#e-PickerLabel { margin-top: 10px; }' +
            '#e-ColorPicker + div { width: 30px; height: 18px; display: inline-block; margin-left: 10px; vertical-align: top; }' +
            // highlight/filter style
            '.e-Highlighted b { font-weight: inherit; }' +
            '.e-Highlighted:not(.e-Transparent), [id^="ta_"][style*="background"] { color: black !important; }' +
            '.e-white:not(.e-Transparent) { color: white !important; }' +
            '.e-black:not(.e-Transparent) { color: black !important; }' +
            '.e-Highlighted:not(.e-Transparent) a { color: inherit !important; }' +
            '.e-Highlighted b { font-weight: bold !important; font-size: 115%; text-decoration: underline; }' +
            // tag divs
            '.e-Tags { position: absolute; top: 0px; left: 0px; text-align: left; color: black; ' +
                'margin-left: 1px; text-shadow: -1px -1px 0 #fff, 1px -1px 0 #fff, -1px 1px 0 #fff, 1px 1px 0 #fff;' +
                'font-weight: bold; font-family: "Segoe UI"; font-size: 12px; line-height: 11px;' +
            '}' +
            '.e-Tags > div { padding: 3px; max-width: 70px; overflow: hidden; transition: max-width .5s linear;' +
                'white-space: nowrap; }' +
            '.id3:hover .e-Tags > div { max-width: 200px !important; }' +
            '.itg, #pp { display: flex; flex-flow: row wrap; }' +
            '.gl1t { float: none !important; }'
        );
        document.head.appendChild(style);

        // Mutable style
            
        EHH.opaqueFilterCSS = document.createElement('style');
        EHH.opaqueFilterCSS.id = 'e-OpaqueFilter';
        EHH.opaqueFilterCSSMask = format('{0}#toppane ~ .c, .e-Filtered { display: none !important; }\n' +
            '{0}tr.color1 { background: %row1 }\n' +
            '{0}tr.color0 { background: %row2 }\n' +
            '{1}#toppane ~ .c, .e-Filtered { opacity: {opacity} !important;}\n' +
            '{1}.e-Filtered:hover { opacity: 1 !important; -webkit-transition: opacity .1s linear;' +
                '-moz-transition: opacity .1s linear; -o-transition: opacity .1s linear; }');
        document.head.appendChild(EHH.opaqueFilterCSS);

        // Popup

        EHH.generatePopup();

        // Events
        
        document.addEventListener('DOMNodeInserted',function(e) {
            if (e.target.nodeName == 'TBODY')
                EHH.walk(e.target);
        },false);

        if (EHH.gallery)
            document.addEventListener('DOMNodeInserted',EHH.updateTagList,false);

        if (!EHH.gallery && !EHH.thumbnails)
            EHH.interceptMouseHover();

        // Data synchronization

        EHH.link('keywords'     , 'keywords' , EHH.updatePopup , EHH.clearRegexes  , EHH.walk);
        EHH.link('filters'      , 'filters'  , EHH.updatePopup , EHH.clearRegexes  , EHH.walk);
        EHH.link('defaultColor' , null       , EHH.updatePopup , EHH.walk);

        EHH.settings.link('defaultColor'       , 'defaultColor');
        EHH.settings.link('exColor'            , 'exColor'     );
        EHH.settings.link('filterEnabled'      , 'filterEnabled'      , EHH.updatePopup , EHH.toggleOpacity , EHH.walk);
        EHH.settings.link('highlighterEnabled' , 'highlighterEnabled' , EHH.updatePopup , EHH.walk);
        EHH.settings.link('opacityEnabled'     , 'opacityEnabled'     , EHH.updatePopup , EHH.toggleOpacity);
        EHH.settings.link('opacity'            , 'opacity'            , EHH.updatePopup , EHH.toggleOpacity);
        EHH.settings.link('showTags'           , 'showTags'           , EHH.toggleTagDivs);
        EHH.settings.link('highlightTags'      , 'highlightTags'      , EHH.highlightTags);
        EHH.settings.link('reorderGalleries'   , 'reorderGalleries'   , EHH.walk);
        EHH.settings.link('hideRatedGalleries' , 'hideRatedGalleries' , EHH.updateMenu, EHH.walk);
        EHH.settings.link('showHideOption'     , 'showHideOption'     , EHH.updateMenu, EHH.walk);
        EHH.settings.link('smartForegrounds'   , 'smartForegrounds'   , EHH.walk);
        EHH.settings.link('chronologicalOrder' , 'chronologicalOrder' , EHH.walk);

        // Start
        
        EHH.toggleOpacity();
        EHH.attachListener();
        EHH.walk();

    },
    
    augmentJS: function() {

        /*Object.getOwnPropertyNames(Array.prototype).forEach(function(x) {
            NodeList.prototype[x] = Array.prototype[x];
        });*/

        var linkedObjects = { };
        Object.defineProperty(Object.prototype,'link', {
            enumerable   : false,
            configurable : false,
            writable     : false,
            value        : function(localProperty,storedProperty,onChangeCallbacks) {
                var currentValue = this[localProperty], args = arguments;
                var get = function() { return currentValue; };
                var set = function(value)  {
                    currentValue = value;
                    if (storedProperty) Utils.save(storedProperty,currentValue);
                    for (var i=2;i<args.length;++i) {
                        if (args[i])
                            args[i](currentValue);
                    }
                };
                delete this[localProperty];
                var descriptor = { get: get, set: set, enumerable: true, configurable: true };
                Object.defineProperty(this,localProperty,descriptor);
                linkedObjects[storedProperty] = { object: this, key: localProperty };
            }
        });

        window.addEventListener('storage',function(e) {
            if (!linkedObjects.hasOwnProperty(e.key)) return;
            var target = linkedObjects[e.key];
            target.object[target.key] = JSON.parse(e.newValue);
        },false);

    },

    addMenuItems: function() {

        var target = document.querySelector('#searchbox .nopm + .nopm, .nosel + div > form > div + div');
        if (!target) return;

        var label = document.createElement('label');
        label.id = 'hideRatedLabel';

        var input = document.createElement('input');
        input.type = 'checkbox';
        Utils.linkCheckbox(input,EHH.settings,'hideRatedGalleries');

        label.appendChild(input);
        label.appendChild(document.createTextNode('Hide rated galleries'));
        label.setAttribute('title', 'Note that you must use a star color other than yellow in order for this feature to work.');

        target.appendChild(document.createTextNode('\u00A0'));
        target.appendChild(document.createTextNode('\u00A0'));
        target.appendChild(label);

    },

    updateMenu: function() {

        EHH.settings.doFilterRated = (EHH.settings.showHideOption && EHH.settings.hideRatedGalleries);

        if (!document.getElementById('hideRatedLabel')) return;

        if (!EHH.settings.showHideOption) className = '';
        else if (!EHH.settings.hideRatedGalleries) className = 'visible';
        else className = 'visible active';

        document.querySelector('#hideRatedLabel input').checked = EHH.settings.hideRatedGalleries;
        document.querySelector('#hideRatedLabel').className = className;
        
    },

    generatePopup: function() {
            
        EHH.popup = document.createElement('div');
        EHH.popup.id = 'e-HentaiPopup';
        EHH.popup.className = 'ido';
        EHH.popup.setAttribute('mode','default');
        EHH.popup.innerHTML =
            '<div id="e-Header">' +
                '<b>E-H Highlighter</b>' +
                '<a id="e-ToggleMode" target="settings">Show settings</a>' +
            '</div><hr/>' +
            '<div mode="default">' +
                '<table align="right">' +
                    '<tr><td style="text-align:left">Keywords:</td><td><a id="e-HighlighterSwitch">Highlighter: enabled</a></tr>' +
                    '<tr><td colspan="2"><textarea></textarea></td></tr>' +
                    '<tr><td style="text-align:left">Filters:</td><td><a id="e-FilterSwitch">Filter: enabled</a></td></tr>' +
                    '<tr><td colspan="2"><textarea></textarea></td></tr>' +
                    '<tr><td colspan="2"><a id="e-PopupSave">Save changes</a><span><b>Filtered items:</b> <span id="e-FilteredItems"></span></span></td></tr>' +
                '</table>' +
            '</div>' +
            '<div mode="settings">' +
                '<label><input type="checkbox" id="opacitySwitch"> Enable opacity mode for filtered items</label>' +
                '<input type="range" name="slider" min="0" max="100"> <span></span>' +
                '<label><input type="checkbox" id="tagDivSwitch">Display any tags matching one or more highlight keywords in front of the gallery thumbnails</label>' +
                '<label><input type="checkbox" id="highlightTagSwitch">Apply highlighting and filters to each gallery\'s tag list</label>' +
                '<label><input type="checkbox" id="chronologicalOrder">Force galleries to appear in chronological upload order (thumbnail mode only)</label>' +
                '<label><input type="checkbox" id="reorderGalleriesSwitch">Move highlighted galleries to the top and filtered galleries to the bottom (thumbnail mode only)</label>' +
                '<label><input type="checkbox" id="showHideOption">Show "hide rated galleries" button on the search box</label>' +
                '<label><input type="checkbox" id="smartForegrounds">Automatically pick the best foreground color (white or black) for highlighted galleries</label>' +
                '<label id="e-PickerLabel"><input type="checkbox" style="visibility: hidden">Default highlight color: <input type="color" id="e-ColorPicker"> <div></div></label>' + 
                '<div id="e-Buttons">' +
                    '<div class="e-Button" id="e-Export">Export data</div>' +
                    '<div class="e-Button" id="e-Import">Import data</div><input type="file" accept="application/json">' +
                '</div>' +
            '</div>';
        document.body.appendChild(EHH.popup);
        
        // Popup elements

        EHH.highlighterSwitch = document.getElementById('e-HighlighterSwitch');
        EHH.filterSwitch      = document.getElementById('e-FilterSwitch');

        var textareas         = Utils.query('#e-HentaiPopup textarea');
        EHH.highlighterArea   = textareas[0];
        EHH.filterArea        = textareas[1];
        
        // Events (default view)

        Utils.onClick(document.getElementById('e-ToggleMode'),function() {
            EHH.popup.setAttribute('mode',this.getAttribute('target'));
            var showSettings = this.getAttribute('target') == 'settings';
            this.innerHTML = (showSettings ? 'Show keywords' : 'Show settings');
            this.setAttribute('target',showSettings ? 'default' : 'settings');
        });
        
        [EHH.highlighterSwitch,EHH.filterSwitch].forEach(function(x) {
            Utils.onClick(x,function() {
                var target = /Highlighter/.test(this.textContent) ? 'highlighterEnabled' : 'filterEnabled';
                var status = /enabled/.test(this.textContent);
                EHH.settings[target] = !status;
            });
        });
        
        Utils.onClick(document.getElementById('e-PopupSave'),function() {
            var validate = function(regexes) { for (var i=0;i<regexes.length;++i) new RegExp(regexes[i]); };
            var keywords = EHH.highlighterArea.value.split(/[\n]/).filter(function(x) { return x.length > 0; });
            var filters  = EHH.filterArea.value.split(/[\n]/).filter(function(x) { return x.length > 0; });
            try {
                validate(keywords);
                validate(filters);
                EHH.dontWalk = true;
                EHH.keywords = keywords;
                EHH.filters = filters;
                EHH.dontWalk = false;
                EHH.walk();
            } catch (e) {
                alert('Couldn\'t parse keyword. ' + e.message + '\nSettings have NOT been saved.');
            }
        });

        // Events (settings view)
        
        Utils.linkCheckbox(document.getElementById('opacitySwitch'),EHH.settings,'opacityEnabled');
        Utils.linkCheckbox(document.getElementById('tagDivSwitch'),EHH.settings,'showTags');
        Utils.linkCheckbox(document.getElementById('highlightTagSwitch'),EHH.settings,'highlightTags');
        Utils.linkCheckbox(document.getElementById('reorderGalleriesSwitch'),EHH.settings,'reorderGalleries');
        Utils.linkCheckbox(document.getElementById('showHideOption'),EHH.settings,'showHideOption');
        Utils.linkCheckbox(document.getElementById('smartForegrounds'),EHH.settings,'smartForegrounds');
        Utils.linkCheckbox(document.getElementById('chronologicalOrder'),EHH.settings,'chronologicalOrder');

        // Opacity slider

        EHH.slider = EHH.popup.querySelector('[name="slider"]');
        if (EHH.slider.type != 'range') EHH.slider = null; // not supported
        else {
            EHH.slider.value = EHH.settings.opacity * 100;
            EHH.slider.nextElementSibling.innerHTML = (Math.floor(EHH.settings.opacity * 10000) / 100) + '%';
            EHH.slider.addEventListener('change',function(e) {
                e.target.nextElementSibling.innerHTML = e.target.value + '%';
                EHH.settings.opacity = parseInt(e.target.value,10) / 100;
            },false);
        }

        // Color picker

        var picker    = document.getElementById('e-ColorPicker'),
            preview   = picker.nextElementSibling,
            supported = picker.type == 'color';

        picker.value = preview.style.backgroundColor = EHH.defaultColor;
        if (supported) picker.style.cssText = 'padding: 0px; border: 0px; background: none; position: relative; top: 3px';
        else picker.style.cssText = 'width: 60px; color: black';
        preview.style.cssText = (supported ? 'display: none;' : 'background-color: ' + EHH.defaultColor);

        var lastColor = preview.style.backgroundColor;
        picker.addEventListener(supported ? 'change' : 'input',function() {
            preview.style.backgroundColor = picker.value;
            if (preview.style.backgroundColor == lastColor) return;
            lastColor = preview.style.backgroundColor;
            EHH.settings[EHH.onPanda ? 'exColor' : 'defaultColor'] = picker.value;
            EHH.defaultColor = picker.value;
        },false);

        // Import-export functions

        var importButton = document.getElementById('e-Import'), importInput = importButton.nextElementSibling;
        Utils.onClick(importButton,function() { importInput.click(); });
        importInput.addEventListener('change',function(e) {
            var reader = new FileReader();
            reader.onerror = function(e) { alert('Couldn\'t read the selected file.'); };
            reader.onload = function(e) {
                try {
                    var data = JSON.parse(this.result);
                    if (!data.keywords || !data.filters || !data.settings) throw null;
                    var confirmation = confirm('This will overwrite your data. Are you sure you want to proceed?');
                    if (confirmation) {
                        EHH.dontWalk = true;
                        EHH.keywords = data.keywords;
                        EHH.filters  = data.filters;
                        for (var key in EHH.settings) EHH.settings[key] = data.settings[key];
                        setTimeout(function() { window.location.reload(); },50);
                    }
                }
                catch (_) { alert('Couldn\'t recognize the selected file.'); }
            };
            reader.readAsText(this.files[0]);
        },false);

        Utils.onClick(document.getElementById('e-Export'),function() {
            var result = { keywords: EHH.keywords, filters: EHH.filters, settings: EHH.settings };
            var blob = new Blob([JSON.stringify(result,null,2)],{ type: 'application/json' });
            var a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'EHH.settings.' + (new Date().valueOf()) + '.json';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        });

        EHH.updatePopup();

    },

    updatePopup: function() {

        var updateSwitch = function(target,enable) {
            target.textContent = target.textContent.replace(/[^\s]+$/,enable ? 'enabled' : 'disabled');
            target.className   = enable ? 'e-Disable' : 'e-Enable';
            var filtered = document.getElementsByClassName('e-Filtered').length;
            document.getElementById('e-FilteredItems').textContent = filtered;
        };

        EHH.highlighterArea.textContent = EHH.keywords.join('\n');
        EHH.filterArea.textContent      = EHH.filters.join('\n');
        updateSwitch(EHH.highlighterSwitch,EHH.settings.highlighterEnabled);
        updateSwitch(EHH.filterSwitch,EHH.settings.filterEnabled);

        document.getElementById('opacitySwitch').checked = EHH.settings.opacityEnabled;

    },

    toggleOpacity: function() {
        // changes the mutable style to enable or disable opacity
        EHH.opaqueFilterCSS.innerHTML = EHH.opaqueFilterCSSMask
                                           .replace(/\{0\}/g,EHH.settings.opacityEnabled ? '//' : '')
                                           .replace(/\{1\}/g,EHH.settings.opacityEnabled ? '' : '//')
                                           .replace(/\{opacity\}/,EHH.settings.opacity);
        if (EHH.slider) EHH.slider.setAttribute('visible',EHH.settings.opacityEnabled);
    },

    attachListener: function() {
        if (!window || !window.addEventListener) return;
        window.addEventListener('message', function(message) {
            if (message.data == 'ehWalk')
                EHH.walk();
        });
    },

    toggleTagDivs: function() {
        Utils.query('.e-Tags').forEach(function(x) {
            x.style.display = EHH.settings.showTags ? null : 'none';
        });
    },

    clearRegexes: function() {
        EHH.parse.regexes = null;
    },
    
    prepareRegexes: function() {
    
        /* Returns an object containing two properties:
         *     highlight : an array of keywords; each element is an object with a "type" property ("tag" or "title"),
         *                 a "regex" property, a "color" property (null if no color is specified for that keyword)
         *                 and optional "excludeTitle" and "excludeTags" properties. Keywords will be checked
         *                 sequentially; the first matching keyword with a color specified will decide the item's
         *                 color. If no color is found but the item still has to be highlighted, EHH.defaultColor
         *                 will be used instead
         *     filters   : an object with two properties (tag and title), each one a regular expression to
         *                 be applied to the relevant target
         */

        var splitFilter = function(x,target) {
            if (x.length > 0 && x[0] == ':') target.tag.push(x.slice(1));
            else if (x.length > 0) target.title.push(x);
        };

        var highlight = EHH.keywords.map(function(x) {
            var type = (x[0] == ':' ? 'tag' : 'title');
            if (type == 'tag') x = x.slice(1);
            var tokens = x.match(/^([^!\/;]+)(![^\/;]+)?(;[^\/]+)?(\/\/?[^\/]+)?$/);
            if (!tokens) {
                console.error('Unable to parse highlighter "' + x + '"');
                return null;
            }
            var include = tokens[1], excludeTitle = tokens[2], excludeTags = tokens[3], color = tokens[4];
            return {
                regex: new RegExp(include, 'gi'),
                excludeTitle: (excludeTitle && excludeTitle.length > 1 ? new RegExp(excludeTitle.slice(1), 'gi') : null),
                excludeTags: (excludeTags && excludeTags.length > 1 ? new RegExp(excludeTags.slice(1), 'gi') : null),
                type: type,
                color: (color ? color.slice(1) : null)
            };
        });

        var filters = { title: [ ], tag: [ ] };
        EHH.filters.forEach(function(x) {
            if (x[0] == ':') filters.tag.push(x.slice(1));
            else filters.title.push(x);
        });

        if (filters.title.length === 0) filters.title.push('EHH: no active title filter');
        if (filters.tag.length === 0) filters.tag.push('EHH: no active tag filter');

        filters.title = new RegExp('(' + filters.title.join('|') + ')','i');
        filters.tag   = new RegExp('(' + filters.tag.join('|') + ')','i');

        return { highlight: highlight.filter(function(x) { return x !== null; }), filters: filters };

    },

    parse: function(title,tags,rated) {

        /* title : a string, the title of the gallery item to be parsed
         * tags  : an array of objects, each one a tag contained in a tag flag
         * rated : true if the gallery has been rated, false otherwise
         * Uses the object built by EHH.prepareRegexes to decide the course of action for each gallery
         * Returns an object with a "result" property indicating what has to be done
         * Possible values are "highlighted", "filtered" or null for no action
         * Filters take precedence over highlight keywords
         * If the gallery item is to be highlighted, the result will also contain three additional properties:
         * - titleKeywords : a list of title substrings that match one or more keywords (can be empty)
         * - tagKeywords   : a list of matching tags (to be passed to EHH.addTagDiv if EHH.settings.showTags is set, can be empty)
         * - color         : the color the gallery needs to be highlighted in (EHH.defaultColor if the user did not specify any color)
         */

        if (!EHH.parse.regexes)
            EHH.parse.regexes = EHH.prepareRegexes();

        var regexes = EHH.parse.regexes;

        if (EHH.settings.doFilterRated && rated)
            return { result: 'filtered' };

        if (EHH.settings.filterEnabled) {
            var filtered = regexes.filters.title.test(title) || tags.some(function(x) { return regexes.filters.tag.test(x.tag); });
            if (filtered) return { result: 'filtered' };
        }

        if (EHH.settings.highlighterEnabled) {
            var titleKeywords = { }, tagKeywords = { }, color = null;
            regexes.highlight.forEach(function(data) {
                // apply title exclusion
                if (data.excludeTitle !== null && title.match(data.excludeTitle)) return;
                // apply tag highlights + tag exclusion
                if (data.type == 'tag' || data.excludeTags !== null) {
                    var excluded = (data.excludeTags !== null && tags.some(function(tag) { return !!tag.tag.match(data.excludeTags); }));
                    if (!excluded) {
                        tags.forEach(function(tag) {
                            if (tagKeywords.hasOwnProperty(tag.tag) || !tag.tag.match(data.regex)) return;
                            tagKeywords[tag.tag] = tag.color;
                            if (!color) color = data.color;
                        });
                    }
                }
                // apply title highlights
                if (data.type == 'title' && !excluded) {
                    var tokens = title.match(data.regex);
                    if (!tokens) return;
                    tokens = tokens.length == 1 ? tokens : tokens.slice(1);
                    for (var i=0;i<tokens.length;++i) titleKeywords[tokens[i]] = true;
                    if (!color) color = data.color;
                }
            });

            titleKeywords = Object.keys(titleKeywords);
            
            if (titleKeywords.length === 0 && Object.keys(tagKeywords).length === 0) return { result: null };
            return { result: 'highlighted', titleKeywords: titleKeywords, tagKeywords: tagKeywords, color: color || EHH.defaultColor };
        }

        return { result: null };

    },

    computeTagColor: function(tag) {
        // don't use style.backgroundPositionY
        var y = parseInt(tag.style.cssText.split(/\s/).slice(-1)[0],10);
        y = -(y+1) / 17;
        return ['salmon','darkorange','gold','mediumaquamarine','skyblue','mediumorchid'][y];
    },

    // extracts both the title and a list of tags for a given target
    // tags are parsed into objects with "tag" and "color" properties representing
    // respectively the tag itself and the color of their associated tag flag
    extractData: function(target) {
        if (!target) {
            console.warn("extractData(): Target is null");
            return null;
        }
        console.log(target);
        // gl4t glname glft
        // var title = target.querySelector('.it5 > a, .id2 > a, [class^="t2"] > a') || target.querySelector('.itd a');

        var title;
        title = target.querySelector('div > a');
        if (!title) {
            title = target.querySelector('.gl4t > div > a, .glft > a') || target.querySelector('.itd a');
        }
        // Condition extracts title in extended view
        if (!title) {
            title = target.querySelector('div > a');
            title = title.firstChild;
        }
        if (!title && target.className.indexOf('t2') === 0) title = target.firstChild;
        if (!title) {
            console.warn("extractData(): Title extraction failed");
            return null;
        }
        var tags = [ ];
        if (target.hasAttribute('eh-tags')) {
            var tagList = (target.getAttribute('eh-tags') || '').split(/,/);
            tags = tagList
                .map(function(x) { return x.trim(); })
                .filter(function(x) { return x.length > 0; })
                .map(function(x) { return { tag: x, color: 'salmon' }; });
        } else {
            var tagElements = Utils.query(target,'.tft, .tfl');
            tags = tagElements.map(function(x) {
                var color = EHH.computeTagColor(x);
                return x.title.split(/,/).map(function(tag) {
                    return { tag: tag, color: color };
                });
            });
        }

        // flatten list if necessary
        tags = [].concat.apply([], tags);

        var rated = !!target.querySelector('.irb, .irg, .irr');

        return { title: title, tags: tags, rated: rated };

    },

    addTagDiv: function(target,tags) {
        if (!tags || Object.keys(tags).length === 0) return;
        var div = document.createElement('div');
        div.className = 'e-Tags';
        var html = '';
        for (t in tags) {
            var tag = t.replace(/^.+:/,''), color = tags[t];
            html += '<div style="background-color: ' + color + '">' + tag + '</div>';
        }
        div.innerHTML = html;
        if (!EHH.settings.showTags) div.style.display = 'none';
        var temp = target.getElementsByClassName('id3')[0];
        if (temp) temp.firstElementChild.appendChild(div);
        else target.appendChild(div);
    },
    
    walk: function(root) {

        /* walks the DOM to highlight and filter gallery items (or the taglist) */

        if (EHH.gallery) {
            EHH.highlightTags();
            return;
        }

        if (EHH.dontWalk) return;

        var removeTagDiv = function(target) {
            Utils.query(target,'.e-Tags').forEach(function(x) { x.parentNode.removeChild(x); });
        };

        var editTitle = function(target,keywords) {
            var temp = target.innerHTML;
            keywords.forEach(function(keyword) {
                var length = keyword.length, n = target.innerHTML.indexOf(keyword);
                while (n != -1) {
                    temp = temp.slice(0,n) + new Array(length+1).join('\0') + temp.slice(n+length);
                    n = target.innerHTML.indexOf(keyword,n+1); 
                }
            });
            return temp.replace(/\0+/g,function(match,start) {
                return '<b>' + target.innerHTML.slice(start,start+match.length) + '</b>';
            });
        };

        // ----------
 
        var flip    = 1,
			order   = 1,
            targets = Utils.query('[class^="gtr"], [class^="gl1t"], div[class^="t2"], [class^="gl1e"]'),
            groups  = (EHH.settings.reorderGalleries && EHH.thumbnails ? [ [ ], [ ], [ ] ] : null);

		if (EHH.settings.chronologicalOrder && EHH.thumbnails) {
			var ids = targets.map(function(x, n) {
				var target = x.querySelector('.id3 > a');
				if (!target) return [ n, 2**63 + n ];
				var tokens = target.getAttribute('href').match(/\/g\/(\d+)/);
				return [ n, (tokens ? parseInt(tokens[1], 10) : 2**63 + n) ];
			});
			ids.sort(function(a,b) { return b[1] - a[1]; })
			targets = ids.map(function(x) { return targets[x[0]]; });
        }

        targets.forEach(function (target) {
            var data = EHH.extractData(target);

            if (data === null) {
                console.warn("Gallery data is null (E-H Highlighter)");
                return;
            }

            // reset element
            target.className     = target.className.replace(/\s?e-\w+/g,'');
            target.style.cssText = target.style.cssText.replace(/(background-color|order|color):.+?;/g, '');
            // BUG: Condition extracts title in extended view, but does it 
            if (!data.title.innerHTML) {
                data.title.innerHTML = data.title.title;
            }
            data.title.innerHTML = data.title.innerHTML = data.title.innerHTML.replace(/<\/?b>/g,'');
            removeTagDiv(target);

            var parsed = EHH.parse(data.title.textContent,data.tags,data.rated);

            if (parsed.result == 'filtered') {
                target.className += ' e-Filtered';
                if (groups !== null) groups[2].push(target);
            }
            // BUG: extended view reordering not working
            // To fix: add
            // display: flex;
            // flex - flow: row wrap;
            // to the tbody child of <table .itg>
            // and add orders to the list of <tr>s instead of <div .gl1e>s
            else if (parsed.result == 'highlighted') {
                if (parsed.color[0] != '/') { // background color
                    if (parsed.color != 'transparent') {
                        target.className     += ' e-Highlighted';
                        target.style.cssText += 'background-color: ' + parsed.color + ' !important;'; 
                        if (EHH.settings.smartForegrounds) {
                            var bestForeground = EHH.getBestForeground(parsed.color);
                            target.className += ' e-' + bestForeground;
                        }
                    } else {
                        target.className     += ' e-Highlighted e-Transparent';
                    }
                } else { // foreground color
                    target.className     += ' e-Highlighted';
                    target.style.cssText += 'color: ' + parsed.color.slice(1) + ' !important;'; 
                }
                data.title.innerHTML  = editTitle(data.title,parsed.titleKeywords);
                if (EHH.thumbnails) EHH.addTagDiv(target,parsed.tagKeywords);
                if (groups !== null) groups[0].push(target);
            }

            else if (groups !== null)
                groups[1].push(target);

            if (!/^gtr/.test(target.className)) return;
            if (parsed.result == 'filtered' && !EHH.opaque) return;
            flip = (flip+1)%2;
            if (target.className.indexOf('color') == -1) target.className += ' color' + flip;
            else target.className = target.className.replace(/color\d/,'color' + flip);

        });

		if (groups !== null) {
			Array.prototype.concat.apply([ ],groups).forEach(function(g) {
				g.style.cssText += 'order: ' + (order++) + ';';
			});
		};

		targets.forEach(function(target) {
			if (!target.style.order)
				target.style.cssText += 'order: ' + (order++) + ';';
		});
        
        var filtered = document.getElementsByClassName('e-Filtered').length;
        document.getElementById('e-FilteredItems').textContent = filtered;

    },

    highlightTags: function() {
        Utils.query('[id^="ta_"]').forEach(function (x) {
            if (!EHH.settings.highlightTags) {
                x.style.cssText = '';
            } else {
                var fullName = x.id.slice(3).replace(/_/g,' ');
                var data = EHH.parse(fullName,[{ tag: fullName, color: null }]);
                // if no match is found and the tag has an alias, re-run the check on the alias
                if (data.result === null && fullName && x.textContent.indexOf(' | ') > -1) {
                    var namespace = fullName.indexOf(':') === 0 ? '' : fullName.slice(0, fullName.indexOf(':')) + ':';
                    var alias = x.textContent.slice(x.textContent.indexOf(' | ') + 3);
                    fullName = namespace + alias;
                    data = EHH.parse(fullName, [{ tag: fullName, color: null }]);
                }
                x.style.cssText =   data.result == 'filtered'    ? 'text-decoration: line-through'                   :
                                    data.result == 'highlighted' ? 'background-color: ' + data.color.replace(/^\//, '') + ' !important' :
                                                   '';
            }
        });
    },

    updateTagList: function(e) {
        if (e.target.nodeName != 'TABLE' || e.target.parentNode.id != 'taglist') return;
        if (EHH.settings.highlightTags) EHH.highlightTags();
    },

    interceptMouseHover: function(e) {
        if (typeof(MutationObserver) != 'function') return;
        var observer = new MutationObserver(function(e) {
            var thumbnail = e[0].target;
            if (thumbnail.style.visibility == 'hidden')
                Utils.query(thumbnail,'.e-Tags').forEach(function(x) { x.parentNode.removeChild(x); });
            else if (EHH.settings.showTags) {
                var row  = document.evaluate('ancestor::tr[1]',thumbnail,null,9,null).singleNodeValue,
                    data = EHH.extractData(row);
                if (data === null) return;
                parsed = EHH.parse(data.title.textContent,data.tags);
                if (parsed.result == 'highlighted') EHH.addTagDiv(thumbnail,parsed.tagKeywords);
            }
        });
        Utils.query('.it2[id^="i"]').forEach(function(x) {
            observer.observe(x,{ attributes: true });
        });
    },

    getBestForeground: function(color) {
        if (!EHH.colorCache) EHH.colorCache = { };
        if (EHH.colorCache.hasOwnProperty(color)) return EHH.colorCache[color];
        var parsedColor = null, div = null;
        try {
            div = document.createElement('div');
            div.style.color = color;
            document.body.appendChild(div);
            parsedColor = window.getComputedStyle(div).color.match(/(\d+)/g);
            parsedColor = [ parseInt(parsedColor[0], 10), parseInt(parsedColor[1], 10), parseInt(parsedColor[2], 10) ];
        } catch (e) {
            parsedColor = [ 255, 255, 255 ];
        } finally {
            if (div && div.parentNode)
                div.parentNode.removeChild(div);
        }
        var whiteDistance = Math.sqrt(Math.pow(255 - parsedColor[0], 2) + Math.pow(255 - parsedColor[1], 2) + Math.pow(255 - parsedColor[2], 2));
        var blackDistance = Math.sqrt(Math.pow(-parsedColor[0], 2) + Math.pow(-parsedColor[1], 2) + Math.pow(-parsedColor[2], 2));
        var result = (whiteDistance > blackDistance ? 'white' : 'black');
        EHH.colorCache[color] = result;
        return result;
    }

};

var Utils = {

    // moves localStorage-based settings to GM_[gs]etValue when possible
    migrateSettings: function() {
        if (typeof(GM_getValue) == 'undefined' || typeof(GM_setValue) == 'undefined') return;
        if (Utils.load('migrationDone2', false)) return;
        try {
            for (var key in EHH.settings) {
                if (localStorage.getItem(key) === null) continue;
                EHH.settings[key] = JSON.parse(localStorage.getItem(key));
                Utils.save(key, EHH.settings[key]);
            }
            ['keywords', 'filters'].forEach(function(key) {
                if (localStorage.getItem(key) === null) return;
                EHH[key] = JSON.parse(localStorage.getItem(key));
                Utils.save(key,EHH[key]);
            });
            Utils.save('migrationDone2', true);
        } catch (e) { }
    },


    save: function(key,value) {
        if (typeof(GM_setValue) != 'undefined') GM_setValue(key, JSON.stringify(value));
        else localStorage.setItem(key, JSON.stringify(value));
    },

    load: function(key,def) {
        var result = null;
        if (typeof(GM_getValue) != 'undefined') result = GM_getValue(key, null);
        else result = (localStorage.getItem(key) || null);
        return (result === null ? def : JSON.parse(result));
    },

    onClick: function(element,f) {
        element.addEventListener('click',function(e) {
            if (e.which != 1) return;
            if (f) f.call(this);
        },false);
    },

    linkCheckbox: function(checkbox,object,property) {
        if (!object) return;
        if (object.hasOwnProperty(property)) checkbox.checked = object[property];
        Utils.onClick(checkbox,function() { object[property] = checkbox.checked; });
    },

    query: function(root,selector) {
        if (!selector)
            return Array.prototype.slice.call(document.querySelectorAll(root),0);
        else
            return Array.prototype.slice.call(root.querySelectorAll(selector),0);
    }
    
};

EHH.init();