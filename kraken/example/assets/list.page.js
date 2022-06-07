let callId = 100000;
function bootstrap() {
    const titlebarBlank = document.createElement('div');
    titlebarBlank.style.width = '100%';
    titlebarBlank.style.background = '#ffff00';
    titlebarBlank.style.height = mbridge.displayInfo.safeArea.top + 'px';
    document.body.appendChild(titlebarBlank);
    
    const titlebar = document.createElement('div');
    titlebar.style.width = '100%';
    titlebar.style.background = '#ffff00';
    titlebar.style.paddingLeft = '24px';
    titlebar.style.height = '48px';
    titlebar.style.display = 'flex';
    titlebar.style.alignItems = 'center';
    titlebar.appendChild(document.createTextNode('返回'));
    titlebar.addEventListener('click', function back() {
        window.mbridge.navigateBack();
    });
    document.body.appendChild(titlebar);

    // // 修改 display 为 sliver.
    // // container.style.display = 'sliver';
  
    // // 必须指定渲染容器节点滚动方向的尺寸(height).
    const containerWrap = document.createElement('div');
    containerWrap.style.display = 'sliver';
    containerWrap.style.height = (mbridge.displayInfo.viewport.height - mbridge.displayInfo.safeArea.top - 48) + 'px';
    // // 创建 100 个子节点.
    for (let i = 0; i < 100; i++) {
        const ele = document.createElement('div');
        ele.style.background = i % 2 ? '#fff' : '#e6e6e6';
        // Sliver 元素默认滚动方向为垂直方向
        // 它的子元素在水平方向上的尺寸(width)会被自动撑满.
        ele.style.padding = '35rpx 60rpx';
        ele.appendChild(document.createTextNode(`第 ${i + 1} 个元素`));

        // 模拟内部元素高度不定场景
        if (i % 3 === 0) {
            const img = new Image();
            img.src = 'https://gw.alicdn.com/tfs/TB1.A6OslBh1e4jSZFhXXcC9VXa-229-255.png';
            img.width = '50px';
            ele.appendChild(img);
        }

        containerWrap.appendChild(ele);
    }
    // containerWrap.appendChild(container);
    document.body.appendChild(containerWrap);

    console.log(location.href);
}

mbridge.ready(bootstrap);
 