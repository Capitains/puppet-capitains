# Capitains
class capitains($static_root,
                $assets_source,
                $data_root,
                $app_root,
                $redis_host,
                $repos,
                $workdir,
                $venvdir,
                $ci_url) {
  include capitains::nginx
  include capitains::dependencies
  include capitains::repos
  include capitains::assets

  file { $app_root:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

  file { $data_root:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

  file { "${app_root}/requirements-py3.txt":
    content => template('capitains/requirements-py3.txt.erb'),
  }

  file { "${app_root}/manager.py":
    content => template('capitains/manager.py.erb'),
  }

  file { "${app_root}/app.py":
    content => template('capitains/app.py.erb'),
  }

  file { "${app_root}/hookclean.py":
    content => template('capitains/hookclean.py.erb'),
  }

  file { "${app_root}/templates":
    ensure => symlink,
    target => "${$static_root}/assets/templates"
  }

  python::virtualenv { $app_root:
    ensure       => present,
    require      => Class['capitains::dependencies'],
    version      => '3',
    requirements => "${app_root}/requirements-py3.txt",
    venv_dir     => $venvdir,
    cwd          => $app_root,
  }

  python::gunicorn { 'vhost':
    ensure     => present,
    virtualenv => $venvdir,
    dir        => $app_root,
    bind       => 'localhost:5000',
    appmodule  => 'app:app',
    owner      => 'www-data',
    group      => 'www-data',
  }
}
