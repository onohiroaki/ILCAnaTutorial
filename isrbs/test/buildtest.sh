ln -s ../share/ilc/250-TDR_ws-ee.circe2 .
gfortran -g -fpic -shared subtest.F -o libsubtest.so
gfortran submain.F libsubtest.so
export LD_LIBRARY_PATH=./:${LD_LIBRARY_PATH}

