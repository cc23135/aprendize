import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 100, // Dobro do radius do CircleAvatar para cobrir o espaço total
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Cor da borda
                      width: 4.0, // Largura da borda
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/mona.png'),
                    backgroundColor: Colors.grey.shade800,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.edit,
                      size: 25,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            // Nome do usuário
            Text(
              'Nobara Kugisaki',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Total de horas estudadas: 184',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 30),
            // Container com cards
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListView(
                  children: <Widget>[
                    Card(
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      child: ListTile(
                        title: Text(
                          'Unicamp - COMVEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '1.234 Estudantes',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(Icons.group, color: Colors.white),
                      ),
                    ),
                    Card(
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      child: ListTile(
                        title: Text(
                          'ITA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '1.234 Estudantes',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(Icons.group, color: Colors.white),
                      ),
                    ),
                    // Adicione mais cartões conforme necessário
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Botão de logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Cor de fundo
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: Text('Sair', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
