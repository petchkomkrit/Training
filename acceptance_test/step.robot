*** Settings ***
Library  Collections
Library  RequestsLibrary
Suite Setup  Create Session for service

*** Variables ***
${SERVICE}  ${EMPTY}

*** Test Cases ***
Order one sneaker successfully
   open app (List all product)
   ${selected_product_id}=  Search product using adidas Keywords
#    Log To Console    ${selected_product_id}
   ${product_id}=  show one product detail    ${selected_product_id}
   ${cart_id}=  add selected product to cart  ${product_id}
   show product in cart  ${cart_id}
   ${order_id}=  checkout the cart (Create Order ID)  ${cart_id}
   Log To Console  ${order_id}
   show shipping method with shipping cost
   add shipping detail  ${order_id}
   add payment detail  ${order_id}
   show summary  ${order_id}


*** Keywords ***
Create Session for service
  Create Session  ${SERVICE}  http://localhost:8882

open app (List all product)
   &{headers}=  Create Dictionary  Content-Type=application/json
   ${response}=  Get Request    ${SERVICE}    /products  headers=${headers}
   Should Be Equal    ${response.status_code}    ${200}
   ${size}=  Get length    ${response.json()['productlist']}
   Should Be Equal    ${size}    ${2}
#    ${product_name}=  Get product name    ${response.json()['productlist']}
#    Should Be Equal    ${size}    ${2}

Search product using adidas Keywords
   &{headers}=  Create Dictionary  Content-Type=application/json
   ${response}=  Get Request    ${SERVICE}    /products?q=Adidas  headers=${headers}
   Should Be Equal    ${response.status_code}    ${200}
   [Return]   ${response.json()['productlist'][0]['product_id']}

show one product detail
   [Arguments]  ${selected_product_id}
   &{headers}=  Create Dictionary  Content-Type=application/json
   ${response}=  Get Request    ${SERVICE}    /products/${selected_product_id}  headers=${headers}
   Should Be Equal    ${response.status_code}    ${200}
   Should Be Equal  ${response.json()['product_name']}  Adidas1
   [Return]   ${response.json()['product_id']}

add selected product to cart
   [Arguments]  ${product_id}
   &{headers}=  Create Dictionary  Content-Type=application/json
   &{datas}=  Create Dictionary  
   ...  product_id=${product_id}
   ...  product_quantity=1
   ${response}=  Post Request    ${SERVICE}    /carts  headers=${headers}
   ...  data=${datas}
   Should Be Equal    ${response.status_code}    ${200}
   [Return]   ${response.json()['cart_id']}

show product in cart
    [Arguments]  ${cart_id}
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request    ${SERVICE}    /carts/${cart_id}  headers=${headers}
    Should Be Equal    ${response.status_code}    ${200}


checkout the cart (Create Order ID)
    [Arguments]  ${cart_id}
    &{headers}=  Create Dictionary  Content-Type=application/json
   &{datas}=  Create Dictionary  
   ...  cart_id=${cart_id}
   ${response}=  Post Request    ${SERVICE}    /orders  headers=${headers}
   ...  data=${datas}
   Should Be Equal    ${response.status_code}    ${200}
   [Return]   ${response.json()['order_id']}

show shipping method with shipping cost
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request    ${SERVICE}    /shipping?method=KERRY&weight=2&zipcode=10250&country=TH  headers=${headers}
   Should Be Equal  ${response.status_code}    ${200}
   Should Be Equal  ${response.json()['shipping_price']}  200

add shipping detail
    [Arguments]  ${order_id}
    &{headers}=  Create Dictionary  Content-Type=application/json
    &{datas}=  Create Dictionary  
   ...  shipping_customer_name=trainning name
   ...  shipping_address=RJ
   ...  shipping_method=KERRY
   ...  shipping_price=200
   ${response}=  Put Request    ${SERVICE}    /orders/${order_id}/shipping  headers=${headers}
   ...  data=${datas}
   Should Be Equal    ${response.status_code}    ${200}

add payment detail
    [Arguments]  ${order_id}
    &{headers}=  Create Dictionary  Content-Type=application/json
    &{datas}=  Create Dictionary  
   ...  payment_method=7-11
   ...  payment_date=11/07/2018
   ...  payment_status=pending
   ${response}=  Put Request    ${SERVICE}    /orders/${order_id}/payment  headers=${headers}
   ...  data=${datas}
   Should Be Equal    ${response.status_code}    ${200}

show summary
    [Arguments]  ${order_id}
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  Get Request    ${SERVICE}    /orders/${order_id}  headers=${headers}
   Should Be Equal  ${response.status_code}    ${200}
