package crud;

import org.junit.jupiter.api.Test;
import project.wallet.repository.crud.Crud;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestTest {
    public project.wallet.Test subject = new project.wallet.Test();
    @Test
    void add_ok(){
        assertEquals(2,subject.add(1,1));

    }
}
