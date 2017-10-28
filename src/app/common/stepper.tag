<stepper>
  <div class="group">
        <div class="{dot: true, current: current}" each="{current, i in array}">
        </div>
  </div>
 <style>
 stepper {
     .group {
        display: flex;
        flex-direction: row;
     }
     .dot {
        width: 8px;
        height: 8px;
        margin: 0 2px;
        border-radius: 50%;
        //background-color: rgba(0, 0, 0, 0.26);
        border: 1px solid white;
     }
     .current {
        background-color: white;
     }
 }
 </style>
 <script>
    // create the array for the needed size
    getOpts() {
        console.log("Creating array",this.opts.size);
        this.array = [];
        for (let i = 0; i < this.opts.size; i++) {
            if (i+1 == this.opts.current) {
                this.array.push(true);
            } else {
                this.array.push(false);
            }
        }
        console.log("done");
    }
    
    this.on('update', () => {
        this.getOpts();
    })

    this.getOpts();
 </script>
</stepper>
