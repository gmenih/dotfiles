export JAVA_HOME="/opt/homebrew/opt/openjdk"
export PATH="$JAVA_HOME/bin:$PATH"

# libpq is keg-only, so its psql/pg_dump need an explicit prepend
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
