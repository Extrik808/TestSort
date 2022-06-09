@isTest
private with sharing class SortableTest {

    @testSetup static void setup() {
        createPersons(5, 'FirstName', 'LastName', '20', 'Female');
        createPersons(5, 'FirstName', 'LastName', '20', 'Male');
        createPersons(3, 'FirstName', 'LastName', '25', 'Male');
    }

    @isTest
    private static void sortOption1() {
        List<Sortable> values = new List<Sortable>();
        for (Person__c record: [SELECT First_Name__c, Last_Name__c, Gender__c, Age__c FROM Person__c]) {
            values.add(new Sortable(record));
        }

        setSettingForOption1();
        values.sort();

        System.assertEquals(13, values.size());

        for (Integer i = 0; i < values.size(); i++) {
            Person__c person = (Person__c) values[i].getValue();

            if (i <= 4) {
                System.assertEquals('Female', person.Gender__c);
                System.assertEquals('FirstName' + i, person.First_Name__c);
                System.assertEquals('LastName' + i, person.Last_Name__c);
            }

            if (i > 4) {
                System.assertEquals('Male', person.Gender__c);
            }

            if (i <= 9) {
                System.assertEquals('20', person.Age__c);
            }

            if (i > 9) {
                System.assertEquals('25', person.Age__c);
            }
        }
    }

    @isTest
    private static void sortOption2() {
        List<Sortable> values = new List<Sortable>();
        for (Person__c record: [SELECT First_Name__c, Last_Name__c, Gender__c, Age__c FROM Person__c]) {
            values.add(new Sortable(record));
        }

        setSettingForOption2();
        values.sort();

        System.assertEquals(13, values.size());

        for (Integer i = 0; i < values.size(); i++) {
            Person__c person = (Person__c) values[i].getValue();

            if (i <= 4) {
                System.assertEquals('Female', person.Gender__c);
                System.assertEquals('20', person.Age__c);
                System.assertEquals('FirstName' + i, person.First_Name__c);
                System.assertEquals('LastName' + i, person.Last_Name__c);
            }

            if (i > 4) {
                System.assertEquals('Male', person.Gender__c);
            }
        }
    }

    private static void createPersons(Integer count, String firstName, String lastName, String age, String gender) {
        List<Person__c> persons = new List<Person__c>();

        for (Integer i = 0; i < count; i++) {
            persons.add(new Person__c(First_Name__c = firstName + i, Last_Name__c = lastName + i, Age__c = age, Gender__c = gender));
        }

        insert persons;
    }

    private static void setSettingForOption1() {
        List<Sortable.SortWrapper> setting = new List<Sortable.SortWrapper>();
        setting.add(new Sortable.SortWrapper(Person__c.Age__c, true));
        setting.add(new Sortable.SortWrapper(Person__c.Gender__c, 'Female'));
        setting.add(new Sortable.SortWrapper(Person__c.First_Name__c, true));
        setting.add(new Sortable.SortWrapper(Person__c.Last_Name__c, false));
        Sortable.setSortSettings(setting);
    }

    private static void setSettingForOption2() {
        List<Sortable.SortWrapper> setting = new List<Sortable.SortWrapper>();
        setting.add(new Sortable.SortWrapper(Person__c.Gender__c, 'Female'));
        setting.add(new Sortable.SortWrapper(Person__c.First_Name__c, true));
        setting.add(new Sortable.SortWrapper(Person__c.Last_Name__c, false));
        setting.add(new Sortable.SortWrapper(Person__c.Age__c, true));
        Sortable.setSortSettings(setting);
    }
}