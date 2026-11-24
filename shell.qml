import Quickshell
<<<<<<< HEAD
import Quickshell.Wayland

ShellRoot {
    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false;
            Qt.quit();
        }
    }

    WlSessionLock {
        id: lock
        locked: true
=======
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

import qs.modules
import qs.modules.lockscreen

ShellRoot {
    Volume {}

    LockContext {
        id: lockContext
        onUnlocked: sessionLock.locked = false
    }

    WlSessionLock {
        id: sessionLock
        locked: false
>>>>>>> 2921af0 (feat: lockscreen and volume)

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }
<<<<<<< HEAD
=======

    IpcHandler {
        target: "lock"

        function lock(): void {
            sessionLock.locked = true;
        }
        function unlock(): void {
            sessionLock.locked = false;
        }
        function isLocked(): bool {
            return sessionLock.locked;
        }
    }
>>>>>>> 2921af0 (feat: lockscreen and volume)
}
