!function(e){var t={};function n(r){if(t[r])return t[r].exports;var o=t[r]={i:r,l:!1,exports:{}};return e[r].call(o.exports,o,o.exports,n),o.l=!0,o.exports}n.m=e,n.c=t,n.d=function(e,t,r){n.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:r})},n.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},n.t=function(e,t){if(1&t&&(e=n(e)),8&t)return e;if(4&t&&"object"===typeof e&&e&&e.__esModule)return e;var r=Object.create(null);if(n.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var o in e)n.d(r,o,function(t){return e[t]}.bind(null,o));return r},n.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return n.d(t,"a",t),t},n.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},n.p="/packs-test/",n(n.s=0)}([function(e,t){function n(e,t){var n=document.querySelector(".".concat(e));n&&n.addEventListener("click",(function(e){var n=e.target;if(n.classList.contains("".concat(t,"__edit-link"))){e.preventDefault();var r=n.closest(".".concat(t));if("Cancel"===n.textContent)return n.textContent="Edit",void r.querySelector(".form_type_inline").classList.add("hidden");n.textContent="Cancel",r.querySelector(".form_type_inline").classList.remove("hidden")}}))}document.addEventListener("turbolinks:load",(function(){n("questions","question"),n("answers","answer")}))}]);
//# sourceMappingURL=edit-inline-form-10bddbd944b1a4beb49c.js.map