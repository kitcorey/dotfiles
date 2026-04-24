# Load secret environment variables
for file in $HOME/.secrets/*(N); do
  source $file
done
