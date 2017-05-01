def consolidate_cart(cart)
new_hash={}
  cart.each do |element|
    element.each do |key, value|
      if !new_hash.has_key?(key)
        new_hash[key]=value
        new_hash[key][:count]=1
      else
        new_hash[key][:count]+=1
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
   item = coupon_hash[:item]
     if cart.has_key?(item)
       origional_qty = cart[item][:count]
       coupon_qty = origional_qty / coupon_hash[:num]
       qty_after_coupon_applied = origional_qty % coupon_hash[:num]
         if coupon_qty > 0
           cart[item][:count] = qty_after_coupon_applied
           cart["#{item} W/COUPON"] = {
           :price=> coupon_hash[:cost],
           :clearance=> cart[item][:clearance],
           :count=> coupon_qty }
         end
       end
     end
   cart

end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance] === true
      value[:price] = value[:price] -(value[:price]* 0.20)
    end
  end
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
 coupons_applied = apply_coupons(consolidated, coupons)
 clearance_applied = apply_clearance(coupons_applied)

 cart_total = consolidated.collect do |keys,value|
   value[:price]*value[:count]
 end.inject(:+)

 if cart_total >= 100
     cart_total = (cart_total * 0.9).round(2)
   end
   cart_total
end
