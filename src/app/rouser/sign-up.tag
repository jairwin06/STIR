<sign-up>
 <section id="rouser">
     <h1>Rouser</h1>
     <action ref="action"></action>
 </section>
 <style>
 #rouser {
    h1  {
     color: blue;
    }
 }
 </style>
 <script>
    this.on('mount', () => {
        console.log("Rouser mounted");
        
    });

    this.on('unmount', () => {
    });


 </script>
</rouser>
