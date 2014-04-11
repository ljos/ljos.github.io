
package ljos.adapter;

import java.lang.reflect.Type;

import ljos.message.Message;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;

public class MessageDeserializer implements JsonDeserializer<Message> {
    @Override
    public Message deserialize(JsonElement json, Type typeOfT,
            JsonDeserializationContext context) throws JsonParseException {
        JsonObject jobj = json.getAsJsonObject();

        String type = jobj.get("type").getAsString().toLowerCase();
        try {
            Class<?> c = Class.forName("ljos.message."
                    + Character.toTitleCase(type.charAt(0))
                    + type.substring(1)
                    + "Message");
            return context.deserialize(json, c);
        } catch (ClassNotFoundException e) {
            throw new JsonParseException("Unrecognized action type: " + type);
        }
    }
}
