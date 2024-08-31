import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import willDestroy from "@ember/render-modifiers/modifiers/will-destroy";
import loadScript from 'discourse/lib/load-script';

export default class BarsGPT extends Component {
  @tracked slot;

  @action
  async register() {
    await loadScript(`https://securepubads.g.doubleclick.net/tag/js/gpt.js`);
    window.googletag = window.googletag || {cmd: []};
    googletag.cmd.push(() => {
      // Define an ad slot for div with id div_id.
      this.slot = googletag
          .defineSlot(this.args.params.ad_unit_path, [this.args.params.width, this.args.params.height], this.args.params.div_id);

      // Enble services.
      googletag.enableServices();
    });

    googletag.cmd.push(() => {
      // Request and render an ad for the slot for given div_id.
      googletag.display(this.args.params.div_id);
    });
  }

  @action
  async unregister() {
    await loadScript(`https://securepubads.g.doubleclick.net/tag/js/gpt.js`);
    // Remove the slot from the page.
    googletag.cmd.push(() => {
      googletag.destroySlots([this.slot]);
    });
  }

  <template>
    <div id={{htmlSafe this.args.params.div_id}} style="width: {{htmlSafe this.args.params.width}}px; height: {{htmlSafe this.args.params.height}}px"
      {{didInsert this.register}}
      {{willDestroy this.unregister}}>
    </div>
  </template>
}
