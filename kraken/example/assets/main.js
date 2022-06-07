function bootstrap() {
    var displayInfo = mbridge.displayInfo;
    const titlebar = document.createElement('div');
    titlebar.style.width = '100%';
    titlebar.style.height = displayInfo.safeArea.top + 'px';
    document.body.appendChild(titlebar);
    var text1 = document.createTextNode('Hello World!');
    var br = document.createElement('br');
    var text2 = document.createTextNode('你好，世界！3');
    var p = document.createElement('p');    
    p.style.textAlign = 'center';
    p.appendChild(text1);
    p.appendChild(br);
    p.appendChild(text2);

    document.body.appendChild(p);

    function createLink(bundle, name) {
        var link = document.createElement('a');
        link.setAttribute('href', bundle);
        link.style.width = '100%';
        link.style.display = 'block';
        link.style.padding = '20px 50px';
        link.appendChild(document.createTextNode(name));
        document.body.appendChild(link);
    }

    function createButton(text, callback) {
        const ele = document.createElement('div');
        ele.style.background = '#e6e6e6';
        ele.style.padding = '35rpx 60rpx';
        ele.style.margin = '35rpx 0';
        ele.appendChild(document.createTextNode(text));
        ele.addEventListener('click', callback);
        document.body.appendChild(ele);
    }

    mbridge.print('app init deviceInfo=', displayInfo);

    createButton('List', function () {
        location.href = 'assets/list.page.js';
    });

    createButton('Audio', function () {
        location.href = 'assets/audio.page.js';
    });

    createButton('Video', function () {
        window.open('assets/video.page.js?bgcolor=' + encodeURIComponent(''));
    });

    createButton('Alert', function () {
        mbridge
            .invokeMethod('alert', {
                title: '提示',
                message: '你好啊？',
                cancelButtonTitle: '取消',
            })
            .then((result) => {
                mbridge.print('data from native', result);
            })
            .catch((err) => {
                mbridge.print('some error occured', err);
            });
    });

    createButton('Load Module', function () {
        window.__require_async__('assets/module1.js').then(function (module) {
            module.say();
        });
    });

    createButton('Log', function () {
        window.open(
            'kranken://startapp/?appid=100001&url=' +
                encodeURIComponent('assets/log.page.js?id=111'),
        );
    });

    createButton('Storage', function () {
        window.open('assets/storage.page.js');
    });

    createButton('Gesture', function () {
        window.open(
            'kranken://startapp/?appid=100001&popGesture=0&url=' +
                encodeURIComponent('assets/gesture.page.js?id=111'),
        );
    });

    var input = document.createElement('input');
    input.placeholder = '请输入...';
    input.value = 'something';
    input.style.width = '200px';
    input.style.height = '50px';
    input.style.fontSize = '20px';
    input.style.margin = '0 35px';
    document.body.appendChild(input);

    mbridge.registerNotifyListener('resize', function (args) {
        console.log('main -> resize', method, args);
    });

    mbridge.registerNotifyListener('appLifecycleStateChanged', function (args) {
        console.log('main -> appLifecycleStateChanged', args);
    });
}

window.mbridge.ready(bootstrap);
