int subscriptionNotificationId(String subscriptionId) => subscriptionId.hashCode;

int graceSubscriptionNotificationId(String subscriptionId) =>
    '$subscriptionId-grace'.hashCode;
