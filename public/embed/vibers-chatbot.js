/**
 * 바이버스 챗봇 Embed Script
 *
 * 사용법: 아무 사이트에 아래 스크립트 태그 하나만 추가
 *
 * <script
 *   src="https://ai.vibers.co.kr/embed/vibers-chatbot.js"
 *   data-service="디어스"
 *   data-api="https://zeroclaw-dus.vibers.co.kr/webhook"
 *   data-token="zc_xxx"
 *   data-color="#4B6BFB"
 *   data-greeting="안녕하세요! 디어스입니다."
 *   data-inquiry="https://designd.co.kr/contact"
 *   defer
 * ></script>
 */
(function () {
  'use strict';
  if (window.__VIBERS_CHATBOT__) return;
  window.__VIBERS_CHATBOT__ = true;

  // ━━━ Config ━━━
  var script = document.currentScript;
  var C = {
    service: attr('service', '바이버스'),
    api: attr('api', ''),
    token: attr('token', ''),
    color: attr('color', '#4B6BFB'),
    greeting: attr('greeting', '안녕하세요! 무엇을 도와드릴까요?'),
    inquiry: attr('inquiry', ''),
    inquiryLabel: attr('inquiry-label', '문의하기 바로가기'),
    responseTime: attr('response-time', '몇 분 내 답변 받으실 수 있어요'),
    profileImg: attr('profile-img', ''),
    size: attr('size', 'large'),
    position: attr('position', 'right'),
  };

  function attr(name, fallback) {
    return script && script.getAttribute('data-' + name) || fallback;
  }

  var SIZES = { small: [360, 500], medium: [400, 600], large: [440, 700] };

  // ━━━ State ━━━
  var isOpen = false;
  var messages = [];
  var isTyping = false;
  var currentSize = C.size;

  // ━━━ DOM ━━━
  var root, fab, chatWin, msgList, inputEl;

  function init() {
    injectStyles();
    root = el('div', { id: 'vb-chat-root' });
    document.body.appendChild(root);
    renderFab();
  }

  // ━━━ FAB (플로팅 버튼) ━━━
  function renderFab() {
    root.innerHTML = '';
    fab = el('button', {
      class: 'vb-fab',
      'aria-label': '채팅 열기',
      onclick: function () { openChat(); },
    });
    fab.style.background = C.color;
    fab.innerHTML = SVG.chat;
    root.appendChild(fab);
  }

  // ━━━ Chat Window ━━━
  function openChat() {
    isOpen = true;
    root.innerHTML = '';

    var dim = SIZES[currentSize] || SIZES.large;
    chatWin = el('div', { class: 'vb-window vb-animate-in' });
    chatWin.style.width = dim[0] + 'px';
    chatWin.style.height = dim[1] + 'px';

    // Header
    var header = el('div', { class: 'vb-header' });

    var backBtn = el('button', { class: 'vb-icon-btn', 'aria-label': '닫기', onclick: closeChat });
    backBtn.innerHTML = SVG.back;

    var profile = C.profileImg
      ? el('img', { class: 'vb-profile', src: C.profileImg, alt: '' })
      : el('div', { class: 'vb-profile-fallback' });
    if (!C.profileImg) {
      profile.style.background = C.color;
      profile.textContent = C.service.slice(0, 2);
    }

    var info = el('div', { class: 'vb-header-info' });
    info.innerHTML = '<div class="vb-header-name">' + esc(C.service) + '</div>'
      + '<div class="vb-header-sub">' + esc(C.responseTime) + '</div>';

    var menuBtn = el('button', { class: 'vb-icon-btn', 'aria-label': '메뉴', onclick: toggleMenu });
    menuBtn.innerHTML = SVG.menu;

    header.appendChild(backBtn);
    header.appendChild(profile);
    header.appendChild(info);
    header.appendChild(menuBtn);

    // Menu dropdown
    var menuDrop = el('div', { class: 'vb-menu', id: 'vb-menu' });
    menuDrop.style.display = 'none';
    menuDrop.innerHTML = [
      menuItem('🔄', '대화 초기화', function () { messages = []; addGreeting(); renderMessages(); hideMenu(); }),
      menuItem('📏', '창 크기: 크게', function () { resizeTo('large'); }),
      menuItem('📏', '창 크기: 보통', function () { resizeTo('medium'); }),
      menuItem('📏', '창 크기: 작게', function () { resizeTo('small'); }),
      C.inquiry ? menuItem('🌐', '홈페이지', function () { window.open(C.inquiry, '_blank'); hideMenu(); }) : '',
    ].join('');

    // Messages
    msgList = el('div', { class: 'vb-messages' });

    // Input
    var inputArea = el('div', { class: 'vb-input-area' });
    var inputWrap = el('div', { class: 'vb-input-wrap' });

    inputEl = el('textarea', {
      class: 'vb-input',
      placeholder: '메시지를 입력해주세요.',
      rows: 1,
    });
    inputEl.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); }
    });
    inputEl.addEventListener('input', function () {
      this.style.height = '20px';
      this.style.height = Math.min(this.scrollHeight, 100) + 'px';
      updateSendBtn();
    });

    var fileInput = el('input', { type: 'file', style: 'display:none', id: 'vb-file' });
    var attachBtn = el('button', { class: 'vb-icon-btn vb-input-icon', 'aria-label': '파일', onclick: function () { fileInput.click(); } });
    attachBtn.innerHTML = SVG.attach;

    var emojiBtn = el('button', { class: 'vb-icon-btn vb-input-icon', 'aria-label': '이모지', onclick: toggleEmojiPicker });
    emojiBtn.innerHTML = SVG.emoji;

    var sendBtn = el('button', { class: 'vb-send-btn', id: 'vb-send', 'aria-label': '전송', onclick: sendMessage });
    sendBtn.style.background = '#ddd';
    sendBtn.innerHTML = SVG.send;

    inputWrap.appendChild(inputEl);
    inputWrap.appendChild(fileInput);
    inputWrap.appendChild(attachBtn);
    inputWrap.appendChild(emojiBtn);
    inputWrap.appendChild(sendBtn);
    inputArea.appendChild(inputWrap);

    // Close button (bottom)
    var closeBtn = el('button', { class: 'vb-close-btn', 'aria-label': '닫기', onclick: closeChat });
    closeBtn.innerHTML = SVG.close;

    chatWin.appendChild(header);
    chatWin.appendChild(menuDrop);
    chatWin.appendChild(msgList);
    chatWin.appendChild(inputArea);
    root.appendChild(chatWin);
    root.appendChild(closeBtn);

    if (messages.length === 0) addGreeting();
    renderMessages();
    inputEl.focus();
  }

  function closeChat() {
    isOpen = false;
    renderFab();
  }

  // ━━━ Messages ━━━
  function addGreeting() {
    messages = [{
      role: 'bot',
      text: C.greeting,
      time: now(),
      actions: getQuickActions(),
    }];
  }

  function getQuickActions() {
    var raw = script && script.getAttribute('data-actions');
    if (!raw) return [];
    try { return JSON.parse(raw); } catch (e) { return []; }
  }

  function sendMessage() {
    var text = inputEl.value.trim();
    if (!text) return;
    messages.push({ role: 'user', text: text, time: now() });
    inputEl.value = '';
    inputEl.style.height = '20px';
    updateSendBtn();
    renderMessages();
    callAPI(text);
  }

  function callAPI(text) {
    if (!C.api) {
      messages.push({ role: 'bot', text: 'API 엔드포인트가 설정되지 않았어요.', time: now(), inquiry: true });
      renderMessages();
      return;
    }

    isTyping = true;
    renderMessages();

    var headers = { 'Content-Type': 'application/json' };
    if (C.token) headers['Authorization'] = 'Bearer ' + C.token;

    fetch(C.api, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify({ message: text }),
    })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        isTyping = false;
        var reply = data.response || data.message || data.content || '죄송해요, 잠시 후 다시 시도해주세요.';
        messages.push({ role: 'bot', text: reply, time: now(), inquiry: true });
        renderMessages();
      })
      .catch(function () {
        isTyping = false;
        messages.push({
          role: 'bot',
          text: 'AI 기능이 아직 원활하지 않을 수 있어요.\n관리자에게 알림을 보냈으니 잠시 후 다시 시도해주세요.',
          time: now(),
          inquiry: true,
        });
        renderMessages();
      });
  }

  function renderMessages() {
    if (!msgList) return;
    var html = '';

    for (var i = 0; i < messages.length; i++) {
      var m = messages[i];
      if (m.role === 'bot') {
        html += '<div class="vb-msg-bot-row">'
          + (C.profileImg
            ? '<img class="vb-avatar" src="' + esc(C.profileImg) + '" alt="">'
            : '<div class="vb-avatar" style="background:' + C.color + '">' + esc(C.service.slice(0, 2)) + '</div>')
          + '<div>'
          + '<div class="vb-bubble-bot">' + escNl(m.text) + '</div>';

        // Quick actions
        if (m.actions && m.actions.length) {
          for (var j = 0; j < m.actions.length; j++) {
            html += '<button class="vb-action-btn" style="border-color:' + C.color + ';color:' + C.color + '" '
              + 'onclick="window.__vbAction(\'' + esc(m.actions[j].message || m.actions[j].label) + '\')">'
              + esc(m.actions[j].label) + '</button>';
          }
        }

        // Inquiry link
        if (m.inquiry && C.inquiry) {
          html += '<a class="vb-inquiry-link" href="' + esc(C.inquiry) + '" target="_blank" rel="noopener">'
            + SVG.link + ' ' + esc(C.inquiryLabel) + '</a>';
        }

        html += '<div class="vb-meta">' + esc(C.service) + ', ' + m.time + '</div>'
          + '</div></div>';
      } else {
        html += '<div class="vb-msg-user-row">'
          + '<div class="vb-bubble-user" style="background:' + C.color + '">' + esc(m.text) + '</div>'
          + '</div>'
          + '<div class="vb-meta-right">' + m.time + '</div>';
      }
    }

    if (isTyping) {
      html += '<div class="vb-msg-bot-row">'
        + '<div class="vb-avatar" style="background:' + C.color + '">' + esc(C.service.slice(0, 2)) + '</div>'
        + '<div class="vb-bubble-bot"><div class="vb-dots"><span></span><span></span><span></span></div></div>'
        + '</div>';
    }

    msgList.innerHTML = html;
    msgList.scrollTop = msgList.scrollHeight;
  }

  // Quick action handler (global)
  window.__vbAction = function (msg) {
    messages.push({ role: 'user', text: msg, time: now() });
    renderMessages();
    callAPI(msg);
  };

  // ━━━ Menu ━━━
  function toggleMenu() {
    var m = document.getElementById('vb-menu');
    m.style.display = m.style.display === 'none' ? 'block' : 'none';
  }
  function hideMenu() {
    var m = document.getElementById('vb-menu');
    if (m) m.style.display = 'none';
  }
  function resizeTo(size) {
    currentSize = size;
    hideMenu();
    if (isOpen) openChat();
  }
  function menuItem(icon, label, fn) {
    var id = 'vb-mi-' + Math.random().toString(36).slice(2, 6);
    setTimeout(function () {
      var el = document.getElementById(id);
      if (el) el.onclick = fn;
    }, 50);
    return '<button class="vb-menu-item" id="' + id + '">' + icon + ' ' + esc(label) + '</button>';
  }

  // ━━━ Emoji Picker ━━━
  var EMOJIS = ['😊','👍','❤️','🙏','😂','🎉','👏','🔥','💯','✨','😍','🤔','😢','😮','👋','🙌','💪','⭐','🌟','💡','📌','✅','❌','⚡','🎯','💬','📝','🏠','📱','💻'];

  function toggleEmojiPicker() {
    var existing = document.getElementById('vb-emoji-picker');
    if (existing) { existing.remove(); return; }

    var picker = el('div', { class: 'vb-emoji-picker', id: 'vb-emoji-picker' });
    var grid = '';
    for (var i = 0; i < EMOJIS.length; i++) {
      grid += '<button class="vb-emoji-item" onclick="window.__vbEmoji(\'' + EMOJIS[i] + '\')">' + EMOJIS[i] + '</button>';
    }
    picker.innerHTML = grid;

    var inputArea = chatWin.querySelector('.vb-input-area');
    if (inputArea) inputArea.insertBefore(picker, inputArea.firstChild);
  }

  window.__vbEmoji = function (emoji) {
    if (inputEl) {
      inputEl.value += emoji;
      inputEl.focus();
      updateSendBtn();
    }
    var picker = document.getElementById('vb-emoji-picker');
    if (picker) picker.remove();
  };

  // ━━━ Utils ━━━
  function updateSendBtn() {
    var btn = document.getElementById('vb-send');
    if (btn) btn.style.background = inputEl.value.trim() ? C.color : '#ddd';
  }

  function el(tag, attrs) {
    var e = document.createElement(tag);
    for (var k in attrs) {
      if (k === 'class') e.className = attrs[k];
      else if (k.indexOf('on') === 0) e.addEventListener(k.slice(2), attrs[k]);
      else e.setAttribute(k, attrs[k]);
    }
    return e;
  }

  function esc(s) { var d = document.createElement('div'); d.textContent = s || ''; return d.innerHTML; }
  function escNl(s) { return esc(s).replace(/\n/g, '<br>'); }
  function now() {
    var d = new Date();
    var h = d.getHours(), m = d.getMinutes().toString().padStart(2, '0');
    return (h < 12 ? '오전' : '오후') + ' ' + (h === 0 ? 12 : h > 12 ? h - 12 : h) + ':' + m;
  }

  // ━━━ SVG Icons ━━━
  var SVG = {
    chat: '<svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z"/></svg>',
    back: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 18l-6-6 6-6"/></svg>',
    menu: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="4" y1="6" x2="20" y2="6"/><line x1="4" y1="12" x2="20" y2="12"/><line x1="4" y1="18" x2="20" y2="18"/></svg>',
    send: '<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>',
    attach: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.44 11.05l-9.19 9.19a6 6 0 01-8.49-8.49l9.19-9.19a4 4 0 015.66 5.66l-9.2 9.19a2 2 0 01-2.83-2.83l8.49-8.48"/></svg>',
    emoji: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M8 14s1.5 2 4 2 4-2 4-2"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></svg>',
    close: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>',
    link: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 01-2 2H5a2 2 0 01-2-2V8a2 2 0 012-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>',
  };

  // ━━━ Styles ━━━
  function injectStyles() {
    var css = document.createElement('style');
    css.textContent = '\
#vb-chat-root{position:fixed;bottom:24px;z-index:99999;font-family:"Pretendard",-apple-system,BlinkMacSystemFont,sans-serif;font-size:15px;' + (C.position === 'left' ? 'left:24px' : 'right:24px') + '}\
.vb-fab{width:56px;height:56px;border-radius:50%;border:none;cursor:pointer;color:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 4px 16px rgba(0,0,0,.2);transition:transform .2s}\
.vb-fab:hover{transform:scale(1.1)}\
.vb-window{display:flex;flex-direction:column;border-radius:16px;overflow:hidden;box-shadow:0 8px 32px rgba(0,0,0,.15);background:#fff;max-height:90vh}\
.vb-animate-in{animation:vb-up .25s ease-out}\
@keyframes vb-up{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}\
.vb-header{display:flex;align-items:center;gap:12px;padding:14px 16px;background:#fff;border-bottom:1px solid #f0f0f0;min-height:60px;position:relative}\
.vb-icon-btn{background:none;border:none;cursor:pointer;padding:4px;display:flex;align-items:center;color:#666;font-size:20px}\
.vb-profile{width:36px;height:36px;border-radius:50%;object-fit:cover;background:#e8ecf1}\
.vb-profile-fallback{width:36px;height:36px;border-radius:50%;color:#fff;display:flex;align-items:center;justify-content:center;font-size:14px;font-weight:600}\
.vb-header-info{flex:1;min-width:0}\
.vb-header-name{font-weight:600;font-size:15px;line-height:1.3;color:#1a1a1a}\
.vb-header-sub{font-size:12px;color:#999;line-height:1.3}\
.vb-menu{position:absolute;top:56px;right:12px;background:#fff;border-radius:12px;box-shadow:0 4px 20px rgba(0,0,0,.12);padding:8px 0;z-index:100;min-width:180px}\
.vb-menu-item{display:flex;align-items:center;gap:8px;padding:10px 16px;font-size:14px;color:#333;cursor:pointer;background:none;border:none;width:100%;text-align:left}\
.vb-menu-item:hover{background:#f5f5f5}\
.vb-messages{flex:1;overflow-y:auto;padding:16px;display:flex;flex-direction:column;gap:16px;background:#f7f8fa}\
.vb-msg-bot-row{display:flex;gap:8px;align-items:flex-start;max-width:85%}\
.vb-avatar{width:28px;height:28px;border-radius:50%;color:#fff;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:600;flex-shrink:0;margin-top:2px}\
.vb-bubble-bot{background:#fff;border-radius:4px 16px 16px 16px;padding:12px 16px;line-height:1.6;font-size:14px;color:#333;box-shadow:0 1px 3px rgba(0,0,0,.06);word-break:break-word}\
.vb-msg-user-row{display:flex;justify-content:flex-end}\
.vb-bubble-user{color:#fff;border-radius:16px 4px 16px 16px;padding:10px 16px;line-height:1.5;font-size:14px;max-width:80%;word-break:break-word}\
.vb-meta{font-size:11px;color:#bbb;margin-top:4px}\
.vb-meta-right{font-size:11px;color:#bbb;margin-top:4px;text-align:right}\
.vb-action-btn{display:inline-block;padding:8px 16px;border-radius:8px;border:1px solid;background:#fff;font-size:13px;font-weight:500;cursor:pointer;margin-top:8px;margin-right:6px;transition:all .15s}\
.vb-action-btn:hover{color:#fff!important;background:var(--c)}\
.vb-inquiry-link{display:inline-flex;align-items:center;gap:4px;padding:8px 14px;border-radius:8px;background:#f5f5f5;color:#555;font-size:13px;font-weight:500;cursor:pointer;text-decoration:none;margin-top:8px}\
.vb-inquiry-link:hover{background:#eee}\
.vb-input-area{padding:12px 16px;border-top:1px solid #f0f0f0;background:#fff}\
.vb-input-wrap{display:flex;align-items:flex-end;gap:8px;background:#f5f6f8;border-radius:24px;padding:8px 12px 8px 16px}\
.vb-input{flex:1;border:none;outline:none;background:transparent;font-size:14px;line-height:1.5;resize:none;max-height:100px;min-height:20px;font-family:inherit;color:#333}\
.vb-input-icon{color:#999;font-size:18px}\
.vb-send-btn{width:32px;height:32px;border-radius:50%;border:none;color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all .15s}\
.vb-close-btn{position:absolute;bottom:-48px;left:50%;transform:translateX(-50%);width:40px;height:40px;border-radius:50%;background:#fff;border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;box-shadow:0 2px 8px rgba(0,0,0,.15);color:#666}\
.vb-dots{display:flex;gap:4px;padding:4px 0}\
.vb-dots span{width:6px;height:6px;border-radius:50%;background:#ccc;animation:vb-b 1.2s ease-in-out infinite}\
.vb-dots span:nth-child(2){animation-delay:.15s}\
.vb-dots span:nth-child(3){animation-delay:.3s}\
@keyframes vb-b{0%,80%,100%{transform:scale(0)}40%{transform:scale(1)}}\
.vb-emoji-picker{display:grid;grid-template-columns:repeat(10,1fr);gap:2px;padding:8px 12px;border-top:1px solid #f0f0f0;background:#fff;max-height:120px;overflow-y:auto}\
.vb-emoji-item{border:none;background:none;font-size:20px;cursor:pointer;padding:4px;border-radius:6px;transition:background .1s}\
.vb-emoji-item:hover{background:#f0f0f0}\
';
    document.head.appendChild(css);
  }

  // ━━━ Init ━━━
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
