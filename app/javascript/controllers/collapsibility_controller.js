import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["collapsible"]

  collapseComments() {
    this.collapsibleTargets.forEach(comment => {
      comment.parentElement.hidden = true
    });
  }
}