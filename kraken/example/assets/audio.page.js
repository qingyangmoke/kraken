let beginTime = Date.now();
function initTitleBar(titleText) {
    const titlebar = document.createElement('div');
    titlebar.style.width = '100%';
    titlebar.style.marginTop = mbridge.displayInfo.safeArea.top + 'px';
    titlebar.style.padding = '0 24px';
    titlebar.style.height = '44px';
    titlebar.style.display = 'flex';
    titlebar.style.marginBottom = '4px';
    titlebar.style.alignItems = 'center';
    const leftButton = document.createElement('div');
    leftButton.style.width = '100px';
    leftButton.style.textAlign = 'left';
    leftButton.appendChild(document.createTextNode('返回'));
    titlebar.appendChild(leftButton);

    const title = document.createElement('div');
    title.style.flex = 1;
    title.style.textAlign = 'center';
    title.appendChild(document.createTextNode(titleText));
    titlebar.appendChild(title);
    const rightButton = document.createElement('div');
    rightButton.style.width = '100px';
    titlebar.appendChild(rightButton);

    titlebar.style.boxShadow = '0px 4px 0px 0px rgba(0,0,0,0.02)';
    titlebar.addEventListener('click', function back() {
        mbridge.navigateBack();
    });
    document.body.appendChild(titlebar);
}
function bootstrap() {
    initTitleBar('Audio Page');

    var video = document.createElement('audio');
    video.autoplay = 'true';
    video.loop = 'true';
    video.style.width = '100%';
    video.style.height = '200px';
    document.body.appendChild(video);

    function createButton(text, callback) {
        const ele = document.createElement('div');
        ele.style.background = '#e6e6e6';
        ele.style.padding = '35rpx 60rpx';
        ele.style.margin = '35rpx 0';
        ele.appendChild(document.createTextNode(text));
        ele.addEventListener('click', callback);
        document.body.appendChild(ele);
    }

    video.addEventListener('playing', function () {
        mbridge.print('event: playing');
    });

    video.addEventListener('pause', function () {
        mbridge.print('event: pause');
    });

    video.addEventListener('ended', function () {
        mbridge.print('event: ended');
    });

    video.addEventListener('change', function () {
        mbridge.print('event: change');
    });

    createButton('play', function () {
        video.play();
    });

    createButton('pause', function () {
        video.pause();
        mbridge.print('src', video.videoWidth, video.videoHeight);
    });

    createButton('fastSeek', function () {
        video.fastSeek(0);
    });

    createButton('src', function () {
        video.src = 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';
        mbridge.print('src', video.src);
    });

    createButton('Load Module', function () {
        window.__require_async__('assets/module1.js').then(function (module) {
            module.say();
        });
    });

    mbridge.registerNotifyListener('resize', function (args) {
        mbridge.print('audio.page -> resize', method, args);
    });

    mbridge.registerNotifyListener('appLifecycleStateChanged', function (args) {
        mbridge.print('audio.page -> appLifecycleStateChanged', args);
    });
}

mbridge.ready(bootstrap);
