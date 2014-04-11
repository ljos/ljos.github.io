
package ljos.test.adapter;

import static org.hamcrest.CoreMatchers.hasItems;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;

import ljos.adapter.MessageDeserializer;
import ljos.message.action.Message;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParseException;

@RunWith(JUnit4.class)
public class MessageDeserializerTest {
    private Gson gson;

    @Before
    public void initialize() {
        gson = new GsonBuilder()
            .setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_DASHES)
            .registerTypeAdapter(Message.class, new MessageDeserializer())
            .create();
    }

    @Test
    public void deserializesMoveMessage() {
        String json = "{'type':'move', 'direction':'left'}";
        Message message = gson.fromJson(json, Message.class);
        assertTrue(message instanceof MoveMessage);

        MoveAction action = (MoveMessage)message;
        assertEquals(action.getType(), "move");
        assertEquals(action.getDirection(), "left");
    }

    @Test(expected=JsonParseException.class)
    public void failsOnDeserializationOnNonsense() {
        String json = "{'message':'action', 'type':'nonsense'}";
        gson.fromJson(json, ActionMessage.class);
    }
}
