import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["collapsible"]

  toggleComments() {
    this.collapsibleTargets.forEach(comment => {
      comment.parentElement.hidden = !comment.parentElement.hidden
    });
  }
}