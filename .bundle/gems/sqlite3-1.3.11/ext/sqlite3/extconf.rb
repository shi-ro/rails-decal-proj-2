ENV['RC_ARCHS'] = '' if RUBY_PLATFORM =~ /darwin/

require 'mkmf'

# :stopdoc:

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

# --with-sqlite3-{dir,include,lib}
dir_config("sqlite3")

if RbConfig::CONFIG["host_os"] =~ /mswin/
  $CFLAGS << ' -W3'
end

def asplode missing
  if RUBY_PLATFORM =~ /mingw|mswin/
    abort "#{missing} is missing. Install SQLite3 from " +
          "http://www.sqlite.org/ first."
  else
    abort <<-error
#{missing} is missing. Try 'port install sqlite3 +universal',
'yum install sqlite-devel' or 'apt-get install libsqlite3-dev'
and check your shared library search path (the
location where your sqlite3 shared library is located).
    error
  end
end

asplode('sqlite3.h')  unless find_header  'sqlite3.h'
asplode('sqlite3') unless find_library 'sqlite3', 'sqlite3_libversion_number'

# Functions defined in 1.9 but not 1.8
have_func('rb_proc_arity')

# Functions defined in 2.1 but not 2.0
have_func('rb_integer_pack')

# These functions may not be defined
have_func('sqlite3_initialize')
have_func('sqlite3_backup_init')
have_func('sqlite3_column_database_name')
have_func('sqlite3_enable_load_extension')
have_func('sqlite3_load_extension')
have_func('sqlite3_open_v2')
have_func('sqlite3_prepare_v2')
have_type('sqlite3_int64', 'sqlite3.h')
have_type('sqlite3_uint64', 'sqlite3.h')

create_makefile('sqlite3/sqlite3_native')
