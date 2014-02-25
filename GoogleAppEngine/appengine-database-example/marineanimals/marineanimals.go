/* Name your package identically to this file and its parent directory */
package marineanimals

/* Include libraries for functions that we need */
import (
    "fmt"
    "net/http"
	"appengine"
    "appengine/datastore"
	"encoding/json"
)

/* 
Some basics:

This function prints the server's response:
fmt.Fprint(w, "...")

This function prints to the server's interal log for debugging and maintenance:
c.Infof("User added data successfully.")
*/

/* This is an entry in your database.  Make sure that initial letters are CAPITALIZED. */
type Marinelocation struct {
	X string
	Y string
	Species string
}

func init() {
    http.HandleFunc("/", handler)					/* The function "handler" will run when someone loads the URL <server>/ */
    http.HandleFunc("/customhello", customhello)	/* The function for <server URL>/customhello is "customhello" */
    http.HandleFunc("/addobject", addobject)		/* Function for adding data to the datastore */
	http.HandleFunc("/animals", getobjects)			/* Function for viewing objects in the datastore */
}

func handler(w http.ResponseWriter, r *http.Request) {
	/* Print this when someone accesses the base server URL (e.g. http://<server>.com/) */
    fmt.Fprint(w, "Hello, App Club!")
}

func customhello(w http.ResponseWriter, r *http.Request) {
	/* Print this when someone accesses <server>/customhello (e.g. http://<server>.com/customhello?name=Bob returns "Hello, Bob") */
	username := r.FormValue("name")
    fmt.Fprint(w, "Hello, ", username)
}

func addobject(w http.ResponseWriter, r *http.Request) {
	c := appengine.NewContext(r)
	
	// Add a new Appobject to the datastore.  Marinelocation is the struct defined at the top of the file. */
	newobject := &Marinelocation{
		X: r.FormValue("x"),
		Y: r.FormValue("y"),
		Species: r.FormValue("species"),
	}
	
	// Format: datastore.NewIncompleteKey(context, "subkind", *parentKey)
	key := datastore.NewIncompleteKey(c, "myobjecttype", ParentKey(c))
    if _, err := datastore.Put(c, key, newobject); err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
		return
    }
	fmt.Fprint(w, "Success!\nNew object: ", newobject, "\nSpecies: ", newobject.Species)
}

func getobjects(w http.ResponseWriter, r *http.Request) {
	
	c := appengine.NewContext(r)

	/*
	METHOD 1: Store all database objects in a slice (think array)
	*/
	
	query := datastore.NewQuery("myobjecttype").Ancestor(ParentKey(c)).Limit(100)
	
	/* Another example of a query, returning only whales and listing ones with the lowest X values first:
	query := datastore.NewQuery("myobjecttype").Ancestor(ParentKey(c)).Filter("Animal =", "whale").Order("-X")
	*/
	
	query_count, _ := query.Count(c)
	objects := make([]Marinelocation, 0, query_count)	// objects holds all of the Marinelocations returned by the query
	if _, err := query.GetAll(c, &objects); err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
	//fmt.Fprint(w, "Objects:\n", objects)
	
	// Respond to the HTML request with JSON-formatted location data
	if objectbytes, err := json.Marshal(objects); err != nil {
		c.Infof("Oops - something went wrong with the JSON.\n")
		fmt.Fprint(w, "JSON error")
		return
	} else {
		fmt.Fprint(w, string(objectbytes))	// Print objects in date-descending order as a JSON array
		return
	}
	
	
	/*
	METHOD 2: Iterate over all of the objects in your databse marked with "myobjecttype"
	*/
	
	/*
	query := datastore.NewQuery("myobjecttype").Ancestor(ParentKey(c)).Limit(100)
	
	// Iterate over all Appobjects
	for t := query.Run(c); ; {
		var x Marinelocation
		_, err := t.Next(&x)
		if err == datastore.Done {
			//c.Infof("Finished", newobject.Groupid)
			break
		}
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		// Perform some action on the data here
		fmt.Fprint(w, "Animal: ", x.Species, "\n")
	}
	*/
}

// Get the parent key for the particular Appobject entity group
func ParentKey(c appengine.Context) *datastore.Key {
    // The string "development_appobjectentitygroup" refers to an instance of a LocationEntityGroupType
	// format: datastore.NewKey(context, "groupkind", "groupkind_instance", 0, nil)
    return datastore.NewKey(c, "LocationEntityGroupType", "development_appobjectentitygroup", 0, nil)
}