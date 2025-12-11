import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    minWidth: { type: Number, default: 80 }
  }

  connect() {
    this.isResizing = false
    this.currentColumn = null
    this.startX = 0
    this.startWidth = 0
  }

  startResize(event) {
    event.preventDefault()
    event.stopPropagation()
    
    this.isResizing = true
    this.currentColumn = parseInt(event.currentTarget.dataset.column)
    const header = event.currentTarget.closest('th')
    const table = this.element
    
    this.startX = event.pageX
    this.startWidth = header.offsetWidth
    
    // Get all cells in this column
    const columnIndex = this.currentColumn
    const rows = table.querySelectorAll('tr')
    this.cells = []
    rows.forEach(row => {
      const cell = row.children[columnIndex]
      if (cell) {
        this.cells.push(cell)
      }
    })
    
    document.addEventListener('mousemove', this.handleMouseMove.bind(this))
    document.addEventListener('mouseup', this.handleMouseUp.bind(this))
    
    document.body.style.cursor = 'col-resize'
    document.body.style.userSelect = 'none'
  }

  handleMouseMove(event) {
    if (!this.isResizing) return
    
    const diff = event.pageX - this.startX
    const newWidth = Math.max(this.minWidthValue, this.startWidth + diff)
    
    // Update all cells in the column
    this.cells.forEach(cell => {
      cell.style.width = `${newWidth}px`
      cell.style.minWidth = `${newWidth}px`
    })
  }

  handleMouseUp(event) {
    if (!this.isResizing) return
    
    this.isResizing = false
    this.currentColumn = null
    this.cells = []
    
    document.removeEventListener('mousemove', this.handleMouseMove.bind(this))
    document.removeEventListener('mouseup', this.handleMouseUp.bind(this))
    
    document.body.style.cursor = ''
    document.body.style.userSelect = ''
  }
}



