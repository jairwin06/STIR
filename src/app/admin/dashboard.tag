<dashboard>
 <section id="admin-dashboard">
     <h1 class="title">Dashboard</h1>
     <table>
        <thead>
            <th>Name</th>
            <th>Time</th>
            <th>Assigned to</th>
            <th>Turk it</th>
        </thead>
        <tbody>
            <tr each={ state.admin.alarms }>
                <td>{name}</td>
                <td>{time}</td>
                <td>{assignedTo}</td>
                <td><button>Turk it</button></td>
            </tr>
        </tbody>
    </table>
 </section>

 <style>
  #admin #admin-dashboard  {
    h1 {
     color: black;
    }
    table, th, td {
       border: 1px solid black;
    }
  }
 </style>
 <script>
    this.on('mount', () => {
        console.log("admin dashboard mounted");
    });

    this.on('unmount', () => {
    });

 </script>
</dashboard>
