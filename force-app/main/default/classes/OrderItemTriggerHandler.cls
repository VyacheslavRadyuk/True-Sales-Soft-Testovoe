public with sharing class OrderItemTriggerHandler {
    
    public static void onAfterInsert(Map<Id, OrderItem__c> newOrderItemsMap) {
        Map<String, Decimal> productCountAndPriceMap = getProductCountAndPrice(newOrderItemsMap);
        Order__c relatedOrder = getOrderById(newOrderItemsMap.values()[0].OrderId__c);
        updateOrder(relatedOrder, productCountAndPriceMap.get('TotalProductCount'), productCountAndPriceMap.get('TotalPrice'));
    }

    public static Map<String, Decimal> getProductCountAndPrice(Map<Id, OrderItem__c> newOrderItemsMap) {
        Decimal TotalProductCount = 0;
        Decimal TotalPrice = 0;

        for (Id orderItemId : newOrderItemsMap.keyset()) {
            TotalProductCount += newOrderItemsMap.get(orderItemId).Quantity__c;
            TotalPrice += newOrderItemsMap.get(orderItemId).Price__c;
        }

        return new Map<String, Decimal>{'TotalProductCount' => TotalProductCount, 'TotalPrice' => TotalPrice};
    }

    public static Order__c getOrderById(Id relatedOrderId) {
        return [SELECT Id, TotalProductCount__c , TotalPrice__c FROM Order__c WHERE Id =:relatedOrderId LIMIT 1];
    }

    public static void updateOrder(Order__c relatedOrder, Decimal TotalProductCount, Decimal TotalPrice) {
        relatedOrder.TotalProductCount__c = TotalProductCount;
        relatedOrder.TotalPrice__c = TotalPrice;
        update relatedOrder;
    }
}