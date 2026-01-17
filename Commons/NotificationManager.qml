pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    // Notification list
    property list<Notification> notifications: []
    property int count: notifications.length
    property bool hasNotifications: count > 0

    // Do Not Disturb mode
    property bool dnd: false

    // Signal for new notifications
    signal notificationReceived(Notification notification)

    // Notification server
    NotificationServer {
        id: server
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true
        persistenceSupported: true
        keepOnReload: true

        onNotification: notification => {
            // Track the notification
            notification.tracked = true

            // Add to list (prepend for newest first)
            root.notifications = [notification].concat(root.notifications)

            // Emit signal
            root.notificationReceived(notification)
        }
    }

    // Connection to handle notification dismissal
    Instantiator {
        model: root.notifications

        Connections {
            target: modelData

            function onClosed(reason) {
                // Remove from list
                const idx = root.notifications.indexOf(modelData)
                if (idx !== -1) {
                    let newList = root.notifications.slice()
                    newList.splice(idx, 1)
                    root.notifications = newList
                }
            }
        }
    }

    // Toggle DND
    function toggleDnd() {
        dnd = !dnd
    }

    // Clear all notifications
    function clearAll() {
        // Dismiss all notifications
        for (let i = notifications.length - 1; i >= 0; i--) {
            notifications[i].dismiss()
        }
    }

    // Dismiss a specific notification
    function dismiss(notification) {
        if (notification) {
            notification.dismiss()
        }
    }
}
