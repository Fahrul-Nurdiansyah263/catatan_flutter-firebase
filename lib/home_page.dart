import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'ai.dart';

class CRUDEoperation extends StatefulWidget {
  const CRUDEoperation({super.key});

  @override
  State<CRUDEoperation> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CRUDEoperation> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  final CollectionReference myItems =
      FirebaseFirestore.instance.collection("CRUDitems");

  Future<void> create() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return myDialogBox(
            judul: "Tambahkan Catatan",
            detail: "Tambah",
            onpressed: () {
              String judul = judulController.text;
              String detail = detailController.text;
              addItems(judul, detail);
              Navigator.pop(context);
            },
          );
        });
  }

  void addItems(String judul, String detail) {
    myItems.add({
      'judul': judul,
      'detail': detail,
    });
  }

  Future<void> update(DocumentSnapshot documentSnapshot) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return myDialogBox(
            judul: "Update Catatan",
            detail: "Update",
            onpressed: () async {
              String judul = judulController.text;
              String detail = detailController.text;
              await myItems.doc(documentSnapshot.id).update({
                'judul': judul,
                'detail': detail,
              });
              judulController.text = '';
              detailController.text = '';
              Navigator.pop(context);
            },
          );
        });
  }

  Future<void> delete(String productId) async {
    await myItems.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
        content: Text("Delete Successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text(
              "Catatan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )),
      body: StreamBuilder(
        stream: myItems.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          documentSnapshot['judul'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .end, 
                            children: [
                              IconButton(
                                onPressed: () => update(documentSnapshot),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayDataPage(
                                data: documentSnapshot.data()
                                    as Map<String, dynamic>,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              heroTag: "fab_add",
              onPressed: create,
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: FloatingActionButton(
              heroTag: "fab_ai",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Text("AI"),
            ),
          ),
        ],
      ),
    );
  }

  Dialog myDialogBox({
    required String judul,
    required String detail,
    required VoidCallback onpressed,
  }) =>
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    judul,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              TextField(
                maxLines: null, 
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                controller: judulController,
                decoration: const InputDecoration(
                    labelText: "Masukan Judul",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Container(
                height: 160.0,
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: detailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Masukan Detail',
                    hintStyle: TextStyle(
                      color: Colors.grey[500], 
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  maxLines: null, 
                  textAlign: TextAlign.start, 
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onpressed,
                child: Text(detail),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
}
