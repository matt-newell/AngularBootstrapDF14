public with sharing class ManifestController {

	public Long lastChangedTimeInMillis {get; private set;}

	public ManifestController() {

		//  Your logic to figure out Namespace prefix, best way could be to query a global apex class
        //  and fetch namespace prefix from it.       
        String nameSpacePrefix = '[...]';
         
        StaticResource latestStaticResource = [SELECT LastModifiedDate
                                        FROM StaticResource
                                        // Where NamespacePrefix like :nameSpacePrefix
                                        // add more filters as required here
                                        ORDER BY LastModifiedDate DESC Limit 1];
 
        /*
            Get last mod timestamps for relevant classes and pages which are in cache
            This will make sure that the container page and its class changes leads to a cache auto update as well
        */
        ApexPage latestPage = [SELECT LastModifiedDate FROM ApexPage
                            // Where NamespacePrefix like :nameSpacePrefix
                            // add more filters as required here
                            ORDER BY LastModifiedDate DESC Limit 1];      
        ApexClass latestClass = [SELECT LastModifiedDate FROM ApexClass
                            // Where NamespacePrefix like :nameSpacePrefix
                            // add more filters as required here
                            ORDER BY LastModifiedDate DESC Limit 1];
        //ApexComponent latestComponent = [SELECT LastModifiedDate FROM ApexComponent
                            // Where NamespacePrefix like :nameSpacePrefix
                            // add more filters as required here
                            //ORDER BY LastModifiedDate DESC Limit 1];
 
        // Collect all timestamps
        List<Datetime> allTimeStamps = new List<DateTime>{
            latestPage.LastModifiedDate, 
            latestStaticResource.LastModifiedDate, 
            latestClass.LastModifiedDate//, 
            //latestComponent.LastModifiedDate
        };
         
        allTimeStamps.sort();
        // get the latest one
        Datetime latest = allTimeStamps.get( allTimeStamps.size() - 1 );
 
        this.lastChangedTimeInMillis = latest.getTime();
		
	}
}