#會員驗證
註冊
登入
非登入狀態回到登入頁面（未登入不可用其他功能）

#商店
商店商品陳列
商品詳細資訊
商品加入購物車（可選數量）

#購物車
購物車商品陳列
商品數量編輯
下單時庫存不足，將購物車中該商品數量改為當前庫存量，並跳出alert通知

####################

#*
session、mysql 、html form的資料名稱統一（以mysql為主）
除錯用的反饋資訊沒有刪除(目前完成)

#backstage.jsp
商品圖片是itemId同名的jpg (ex:10000001.jpg），上架的時候不上傳新圖片，而是手動改圖片名丟進productsImg資料夾，考慮修改
業者驗證功能0，也許保留memberId10000000當業者專屬帳號

#cart.jsp
下單後訂單送出與後續功能未完成(訂單要送去哪?用什麼形式儲存?Email信件?資料表?)

#logOut.jsp、addToCart.jsp
可以改成js（暫時不必要）
