let beginTime = Date.now();
function bootstrap() {
    const titlebar = document.createElement('div');
    titlebar.style.width = '100%';
    titlebar.style.marginTop = mbridge.displayInfo.safeArea.top + 'px';
    titlebar.style.paddingLeft = '24px';
    titlebar.style.height = '88px';
    titlebar.style.display = 'flex';
    titlebar.style.alignItems = 'center';
    titlebar.appendChild(document.createTextNode('返回'));
    titlebar.addEventListener('click', function back() {
        window.mbridge.navigateBack();
    });
    document.body.appendChild(titlebar);

    var video = document.createElement('video');
    video.autoplay = 'true';
    video.loop = 'true';
    video.style.width = '100%';
    video.style.height = '200px';
    video.style.display = 'flex';
    video.style.alignItems = 'center';
    document.body.appendChild(video);

    var text1 = document.createTextNode('Hello World!' + (Date.now() - beginTime).toString());
    var br = document.createElement('br');
    var text2 = document.createTextNode('你好，世界！');
    var p = document.createElement('p');
    p.style.textAlign = 'center';
    p.appendChild(text1);
    p.appendChild(br);
    p.appendChild(text2);
    document.body.appendChild(p);

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
        text2.data = 'ended';
    });

    video.addEventListener('change', function () {
        text2.data = video.value;
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

    console.log(location.href);
}

mbridge.ready(bootstrap);
