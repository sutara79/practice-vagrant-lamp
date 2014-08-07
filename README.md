# my_lamp for Chef-solo
Chef-solo recipe to replace XAMPP.

## Environment
##### Virtual
- CentOS 6.5 64bit
- Apache 2.2
- MySQL 5.6
- PHP 5.6
  - phpDocumnetor 2.6.1
  - yaml 1.1.1
- Node.js 0.10.29
  - JSDoc 3.3.0-alpha9
- Git 1.7.1

##### Host
- Windows7 64bit
- VirtualBox 4.3.12
- Vagrant 1.6.3
- Chef-solo 11.14.2

## Note
ホスト、ゲスト双方の共有フォルダを変更しています。
```ruby
config.vm.synced_folder "../../server", "/var/www/html"
```

## Author
Yuusaku Miyazaki (toumin.m7@gmail.com)

## License
[MIT License](http://www.opensource.org/licenses/mit-license.php)