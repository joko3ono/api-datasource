How to use:


config :
set Domain name of you web API on file lib/momod.rb

    DOMAIN = "http://localhost:3001"

Your model will looks like this

class Brand < Momod::Markas
  // attr_accessor used to showing your data from datasource
  attr_accessor :id, :name, :product_count
  // which field you want to editable
  attr_accessible :name
end

Use :

Retrieve data :

Brand.list

  return:
[#<Brand:0x907ffcc @id=1, @name="Adodas", @product_count=nil>, #<Brand:0x907afe0 @id=2, @name="String", @product_count=nil>, #<Brand:0x9078c40 @id=3, @name="goblog", @product_count=nil>, #<Brand:0x9043144 @id=4, @name="testong", @product_count=nil>, #<Brand:0x901a474 @id=5, @name="abcdef", @product_count=nil>, #<Brand:0x90027c0 @id=6, @name="t", @product_count=nil>]

Show 1 data :

Brand.show :id

  return
#<Brand:0x8fa3d4c @id=1, @name="Adodas", @product_count=nil>

Save :

Brand.create name: 'geboy'

  return
#<Brand:0x8fa3d4c @id=1, @name="geboy", @product_count=nil>

OR

brand = Brand.new name: 'geboy'
brand.save

  return
#<Brand:0x8fa3d4c @id=1, @name="geboy", @product_count=nil>


Update

brand = Brand.show 1
brand.update_attributes name: 'boygeboy'

  return
#<Brand:0x8fa3d4c @id=1, @name="boygeboy", @product_count=nil>
