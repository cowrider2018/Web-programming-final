SQL有更新，記得重新建立資料庫

#會員驗證
註冊
登入
非登入狀態回到登入頁面（未登入不可用其他功能）

#商店
商店商品陳列
商品詳細資訊
商品加入購物車（可選數量）
分類顯示

#購物車
購物車商品陳列
商品數量編輯
下單時庫存不足，將購物車中該商品數量改為當前庫存量，並跳出alert通知
送出訂單（存入資料庫）

#後台頁面
業者驗證功能(僅接受memberId=10000000用戶)
上架商品
下架商品
變更商品名、敘述、價格、庫存量等資訊

####################

#*
session、mysql 、html form的資料名稱統一（以mysql為主）
除錯用的反饋資訊沒有刪除(目前完成)

#backstage.jsp
商品圖片是itemId同名的jpg (ex:10000001.jpg），上架的時候不上傳新圖片，而是手動改圖片名丟進productsImg資料夾，考慮修改

#logOut.jsp、addToCart.jsp、order.jsp
可以改成js（暫時不必要）
