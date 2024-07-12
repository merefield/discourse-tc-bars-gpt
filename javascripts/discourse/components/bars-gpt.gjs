import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import loadScript from 'discourse/lib/load-script';

export default class BarsGPT extends Component {

  @action
  async loadAdScript() {
    await loadScript(`https://securepubads.g.doubleclick.net/tag/js/gpt.js`);
    window.googletag = window.googletag || { cmd: [] };
    googletag.cmd.push(() => {
      // Define an ad slot for div with id div_id.
      googletag
        .defineSlot(this.args.params.ad_unit_path, [this.args.params.width, this.args.params.height], this.args.params.div_id)
        .addService(googletag.pubads());

      // Enable the PubAdsService.
      googletag.enableServices();
    });
    googletag.cmd.push(() => {
      // Request and render an ad for the slot for given div_id.
      googletag.display(this.args.params.div_id);
    });
  }

  <template>
    <div id={{htmlSafe this.args.params.div_id}} style="width: {{htmlSafe this.args.params.width}}px; height: {{htmlSafe this.args.params.height}}px"
      {{didInsert this.loadAdScript}}>
    </div>
  </template>
}
