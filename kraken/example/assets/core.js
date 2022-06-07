// TODO: 后期可以放到bridge/polyfill/src/中
function print(msg) {
    var message = Array.prototype.slice
        .call(arguments, 0)
        .map((e) => JSON.stringify(e))
        .concat('getContextId=' + mbridge.getContextId());
    // window.mbridge.invokeMethod('core.log', {
    //     msg: message.join(' '),
    // });
    console.log(message.join(' '));
}
window.__require__modules_map = {};
// 同步加载资源
window.__require__ = function (moduleName) {
    return (window.__require__modules_map[moduleName] || {}).exports;
};
// 异步加载资源
window.__require_async__ = function (moduleName) {
    return new Promise(function (resolve) {
        let module = window.__require__(moduleName);
        if (module) {
            resolve(module);
        } else {
            mbridge
                .invokeModule('Resources', 'loadModule', moduleName)
                .then((result) => {
                    print('register ', result);
                    let module = window.__require__(moduleName);
                    resolve(module);
                })
                .catch((err) => {
                    resolve(null);
                });
        }
    });
};

window.__exports__ = function (moduleName, moduleFunc) {
    const module = {
        exports: {},
    };
    moduleFunc(module);
    window.__require__modules_map[moduleName] = module;
};

var _listeners = {};

kraken.methodChannel.setMethodCallHandler((method, args) => {
    // switch (method) {
    //     case 'appLifecycleStateChanged': // 前后台切换
    //         break;
    //     case 'platformBrightnessChanged': // 黑夜白天模式
    //         break;
    //     case 'resize': // resize事件
    //         break;
    // }
    if (_listeners[method]) {
        _listeners[method].forEach((e) => {
            e(args);
        });
    }
    mbridge.print('notify', method, args);
});

window.mbridge = {
    print: print,
    callId: 1000,
    getContextId: function () {
        return window.__contextId__;
    },
    navigateBack: function () {
        mbridge.invokeModule('Navigation', 'back', '');
    },
    registerNotifyListener(method, callback) {
        _listeners[method] = _listeners[method] || [];
        _listeners[method].push(callback);
    },
    removeNotifyListener(method, callback) {
        if (_listeners[method]) {
            const listeners = _listeners[method];
            if (!callback) {
                _listeners[method] = [];
            } else {
                const index = listeners.indexOf(callback);
                if (index !== -1) {
                    listeners.splice(index, 1);
                }
            }
        }
    },
    invokeMethod: function (methodName, param) {
        param = param || {};
        param.contextId = window.__contextId__;
        return kraken.methodChannel.invokeMethod(methodName, window.mbridge.callId++, param);
    },
    ready: function (callback) {
        mbridge.invokeModule('DeviceInfo', 'getDisplayInfo', '').then((result) => {
            mbridge.displayInfo = result;
            callback();
        });
    },
    invokeModule(moduleName, methodName, param) {
        return new Promise(function (resolve, reject) {
            kraken.invokeModule(moduleName, methodName, param, (e, data) => {
                if (e) return reject(e);
                resolve(data);
            });
        });
    },
    setPopGestureEnabled(enable) {
        mbridge.invokeModule('Navigator', 'popGestureEnabled', enable ? 1 : 0);
    },
};
