*** Settings ***

Library  Collections
Library  RequestsLibrary

*** Variables ***

*** Test Cases ***
Order Adidas
    Open app - get list of all products
    ${selected_product_id}=  Search product by Name = Adidas
    Show product detail of selected product  ${selected_product_id}
    ${cart_id}=  Add selected to cart  ${selected_product_id}
    ${order_id}=  Create Order  ${cart_id}
    Show cart detail with calculated pricing
    Add shipping address  ${order_id}
    Payment  ${order_id}
    Show summary of ordering - success  ${order_id}

*** Keywords ***
Open app - get list of all products
    Create Session   list  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request   list   /products  headers=${headers}
    Should Be Equal   ${response.status_code}   ${200}
    ${size}=  Get Length  ${response.json()['productlist']}
    Should Be Equal   ${size}   ${2}
    [Return]  ${response.json()['productlist'][0]['product_id']}
Search product by Name = Adidas
    Create Session   search  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request   search   /products?q=Adidas  headers=${headers}
    Should Be Equal   ${response.status_code}   ${200}
    [Return]  ${response.json()['productlist'][0]['product_id']}
Show product detail of selected product
    [Arguments]  ${product_id}
    Create Session   search  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request   search   /products/${product_id}  headers=${headers}
    Should Be Equal   ${response.status_code}   ${200}
Add selected to cart
    [Arguments]  ${product_id}
    Create Session   search  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Post Request   search   /carts  headers=${headers}  data={"product_id":${product_id},"product_quantity":"1"}
    Should Be Equal   ${response.status_code}   ${200}
    [Return]  ${response.json()['cart_id']}
Create Order
    [Arguments]  ${cart_id}
    Create Session   order  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Post Request   order   /orders  headers=${headers}  data={"cart_id":${cart_id}}
    Should Be Equal   ${response.status_code}   ${200}
    [Return]  ${response.json()['order_id']}
Show cart detail with calculated pricing
    Create Session   price  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request   price   /shipping?method=KERRY&weight=2&zipcode=10250&country=TH  headers=${headers}
    Should Be Equal   ${response.status_code}   ${200}
    [Return]  ${response.json()['shipping_price']}    
Add shipping address
    [Arguments]  ${order_id}
    Create Session   shipping  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Put Request   shipping   /orders/${order_id}/shipping  headers=${headers}  data={"shipping_customer_name":"trainning name","shipping_address":"RJ","shipping_method":"KERRY","shipping_price":"200"}
    Should Be Equal   ${response.status_code}   ${200}
Payment
    [Arguments]  ${order_id}
    Create Session   payment  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Put Request   payment   /orders/${order_id}/payment  headers=${headers}  data={"payment_method":"7-11","payment_date":"11/07/2018","payment_status":"pending"}
    Should Be Equal   ${response.status_code}   ${200}
Show summary of ordering - success
    [Arguments]  ${order_id}
    Create Session   summary  http://localhost:8882
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request   summary   /orders/${order_id}  headers=${headers}
    Should Be Equal   ${response.status_code}   ${200}