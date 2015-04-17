rm t.beam t0.beam t1.beam

cat t_template.erl | sed -e 's/t_template/t/g' | sed -e 's/__THE_NUMBER__/1/g' > t.erl
erlc -Werror t.erl
cp t.beam t0.beam

cat t_template.erl | sed -e 's/t_template/t/g' | sed -e 's/__THE_NUMBER__/2/g' > t.erl
erlc -Werror t.erl
cp t.beam t1.beam
