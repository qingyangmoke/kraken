function bootstrap() {
    const titlebarBlank = document.createElement('div');
    titlebarBlank.style.width = '100%';
    titlebarBlank.style.marginTop = mbridge.displayInfo.safeArea.top + 'px';
    document.body.appendChild(titlebarBlank);

    const titlebar = document.createElement('div');
    titlebar.style.width = '100%';
    titlebar.style.paddingLeft = '24px';
    titlebar.style.height = '88px';
    titlebar.style.display = 'flex';
    titlebar.style.alignItems = 'center';
    titlebar.appendChild(document.createTextNode('返回'));
    titlebar.addEventListener('click', function back() {
        window.mbridge.navigateBack();
    });
    document.body.appendChild(titlebar);

    function createButton(text, callback) {
        const ele = document.createElement('div');
        ele.style.background = '#e6e6e6';
        ele.style.padding = '35rpx 60rpx';
        ele.style.margin = '35rpx 0';
        ele.appendChild(document.createTextNode(text));
        ele.addEventListener('click', callback);
        document.body.appendChild(ele);
    }

    createButton('Enabled popGesture', function () {
        mbridge.setPopGestureEnabled(1);
    });

    createButton('Disable popGesture', function () {
        mbridge.setPopGestureEnabled(0);
    });
}

window.mbridge.ready(bootstrap);
