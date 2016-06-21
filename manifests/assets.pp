#UI Assets for Capitains
class capitains::assets {
  exec { 'clone assets':
    command => "/usr/bin/git clone ${capitains::assets_source} ${capitains::static_root}",
    creates => $capitains::static_root,
  }
}
