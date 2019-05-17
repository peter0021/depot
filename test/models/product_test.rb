require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  def new_product(img_url)
      Product.new(title: 'Hilow', description:"Only a crazy guy", price: 1, image_url: img_url)
  end

  test "Product should not be empty" do
    product = Product.new  
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "Product price must be positive" do
    product = Product.new(title: "A cabana", description: "Um livro so good to read without your family", image_url: "a.png")

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?

  end

  test "image url check" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.docx fred.html fred.php fred.py fred.word}

    ok.each do |img_url|
      assert new_product(img_url).valid?
          "#{img_url} should't be invalid"
    end
    bad.each do |img_url|
      assert new_product(img_url).invalid?
          "#{img_url} should't be valid"
    end
  end
  test "product is not valid without a unique title" do
    product = Product.new(title:       products(:ruby).title,
                          description: "yyy",
                          price:       1,
                          image_url:   "fred.gif")

    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
  test "product is not valid without a unique title - i18n" do
    product = Product.new(title:       products(:ruby).title,
                          description: "yyy",
                          price:       1,
                          image_url:   "fred.gif")

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end
end
