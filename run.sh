function sep {
    echo "\n\n\n"
}

sh build.sh
erl -boot start_clean -eval 't:a(3).' -s init stop
sep
erl -boot start_clean -eval 't:b(3).' -s init stop
sep
erl -boot start_clean -eval 't:ca(3).' -s init stop
sep
erl -boot start_clean -eval 't:cb(3).' -s init stop
sep
erl -boot start_clean -eval 't:cc(3).' -s init stop
sep
erl -boot start_clean -eval 't:cd(3).' -s init stop
sep
erl -boot start_clean -eval 't:d(t, d, 3).' -s init stop
sep
erl -boot start_clean -eval 't:x(3).' -s init stop
sep
erl -boot start_clean -eval 't:y(3).' -s init stop
sep
