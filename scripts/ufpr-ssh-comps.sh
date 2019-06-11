for comp in xereta montaro astor chuvisco batatinha gaguinho gru bandit crane dundun croc goober catatau farofino shen zebolha mutreta klunk; do
  ssh $comp
done

for j in `seq 1 12`
do
  ssh i$j
done

for j in `seq 30 70`
do
  ssh h$j
done