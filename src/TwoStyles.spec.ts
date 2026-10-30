import { mount } from '@vue/test-utils'
import { expect, test } from 'vitest'
import TwoStyles from './TwoStyles.vue'

test('mounts an SFC with two scoped src styles', () => {
  const wrapper = mount(TwoStyles, { attachTo: document.body })
  const scopeAttr = wrapper.element.getAttributeNames().find((n) => n.startsWith('data-v-'))
  const css = [...document.head.querySelectorAll('style')].map((s) => s.textContent).join('\n')
  console.log(`SCOPE_ATTR=${scopeAttr}\nINJECTED_CSS=${JSON.stringify(css)}`)
  expect(wrapper.text()).toBe('hello')
})
