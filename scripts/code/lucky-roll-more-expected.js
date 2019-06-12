function luckyMore(min, max){
    interval = max - min + 1;

    expected = (min + max)/2
    console.log(expected);
    x = min;
    lucky = 0;
    while(x <= max){
        lucky += (2*x*x - x);
        ++x;
    }
    lucky = lucky / (interval * interval);

    console.log(lucky);
    expected = lucky / expected;
    return expected;
}