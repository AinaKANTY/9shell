import Quickshell
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

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

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
}
