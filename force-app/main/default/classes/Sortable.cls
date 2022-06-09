public class Sortable implements Comparable {

    private Object value;
    public static SortMethod compareMethod;
    public static List<SortWrapper> sortSettings = new List<SortWrapper>();
    public static void setSortSettings(List<SortWrapper> sortSettings) {
        Sortable.sortSettings = sortSettings;
    }

    public interface SortMethod {
        Integer compareTo(Object a, Object b);
    }

    public Sortable(Object value) {
        this.value = value;
    }

    public Object getValue() {
        return value;
    }


    public Integer compareTo(Object other) {
        Integer result;

        for (SortWrapper item : Sortable.sortSettings) {
            Sortable.compareMethod = String.isNotBlank(item.firstIs)
                ? new Sortable.DateFieldSort(item.field, item.firstIs)
                : new Sortable.DateFieldSort(item.field, item.sortASC);
            result = compareMethod.compareTo(this.value, ((Sortable) other).value);

            if (result == 0) {
                continue;
            } else {
                break;
            }
        }

        return result;
    }

    public class DateFieldSort implements SortMethod {
        Boolean sortASC;
        String firstIs;
        SObjectField field;

        public DateFieldSort(SObjectField sortField, Boolean sortAsc) {
            this.sortASC = sortAsc;
            this.field = sortField;
        }

        public DateFieldSort(SObjectField sortField, String sortAsc) {
            this.firstIs = sortAsc;
            this.field = sortField;
        }

        public Integer compareTo(Object a, Object b) {
            SObject left = (SObject)a;
            SObject right = (SObject)b;
            String leftValue = (String)left.get(field);
            String rightValue = (String)right.get(field);

            return String.isNotBlank(firstIs)
                ? compareFirstIs(leftValue, rightValue)
                : compareASCAndDESC(leftValue, rightValue);
        }

        private Integer compareASCAndDESC(String leftValue, String rightValue) {
            if (leftValue == rightValue) return 0;
            if (leftValue > rightValue) return this.sortASC ? 1 : -1;

            return this.sortASC ? -1 : 1;
        }

        private Integer compareFirstIs(String leftValue, String rightValue) {
            if (leftValue == this.firstIs && rightValue != this.firstIs) return -1;
            if (leftValue != this.firstIs && rightValue == this.firstIs) return 1;

            return 0;
        }
    }

    public class SortWrapper {

        public SObjectField field { get; set; }
        public Boolean sortASC { get; set; }
        public String firstIs { get; set; }

        public SortWrapper(SObjectField field, Boolean sortASC) {
            this.field = field;
            this.sortASC = sortASC;
        }

        public SortWrapper(SObjectField field, String firstIs) {
            this.field = field;
            this.firstIs = firstIs;
        }
    }

}