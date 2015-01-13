# practice-vagrant-lamp
Chef-solo recipe to replace XAMPP.  
Only for non-production environment.  
**DO NOT** apply this cookbook to production environment.

## Environment
##### Virtual Machine
- [CentOS 6.5 x86_64](https://github.com/2creatives/vagrant-centos/releases/tag/v6.5.3)
- Apache
- MySQL (mysql56-community)
- PostgreSQL (pgdg94)
- PHP (remi-php56)
  - Composer
  - phpDocumnetor
  - yaml
  - Phalcon
- Node.js (epel)
  - JSDoc
- Git
- Ruby
  - HerokuToolbelt

##### Host Machine
- Windows 7 64bit
- VirtualBox
- Vagrant
  - **DO NOT install plugin**: vagrant-berkshelf, vagrant-omnibus
- chef-client >= 12.0

## Author
Yuusaku Miyazaki (toumin.m7@gmail.com)

## License
[MIT License](http://www.opensource.org/licenses/mit-license.php)