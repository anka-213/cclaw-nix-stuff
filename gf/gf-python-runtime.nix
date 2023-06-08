{gf-core, gf-pgf, buildPythonPackage}:

buildPythonPackage rec {
  name = "gf-python-runtime";
  # Python name: pgf
  src = gf-core + "/src/runtime/python";
  # propagatedBuildInputs = [ pytest numpy pkgs.libsndfile ];
  propagatedBuildInputs = [ gf-pgf ];
}

# setup (name = 'pgf',
#        version = '1.0',
#        description = 'Python bindings to the Grammatical Framework\'s PGF runtime',
#        long_description="""\
# Grammatical Framework (GF) is a programming language for multilingual grammar applications.
# This package provides Python bindings to GF runtime, which allows you to \
# parse and generate text using GF grammars compiled into the PGF format.
# """,
#        url='https://www.grammaticalframework.org/',
#        author='Krasimir Angelov',
#        author_email='kr.angelov@gmail.com',
#        license='BSD',
#        ext_modules = [pgf_module])
#
