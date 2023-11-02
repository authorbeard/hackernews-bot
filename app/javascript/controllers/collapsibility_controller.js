import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["collapsible"]

  collapseComments() {
    this.collapsibleTargets.forEach(comment => {
debugger;
      comment.hidden = true
    });
  }
}