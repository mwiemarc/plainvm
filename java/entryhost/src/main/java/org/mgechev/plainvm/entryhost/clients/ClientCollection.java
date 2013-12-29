package org.mgechev.plainvm.entryhost.clients;

import java.util.HashMap;
import java.util.UUID;

import org.mgechev.plainvm.entryhost.actionhandlers.ActionFacade;
import org.mgechev.plainvm.entryhost.endpoints.EndPointCollection;
import org.mgechev.plainvm.entryhost.messages.Action;
import org.mgechev.plainvm.entryhost.messages.ClientData;

import com.google.gson.Gson;

public enum ClientCollection {
    INSTANCE;
    private HashMap<UUID, Client> clients = new HashMap<UUID, Client>();
    private ActionFacade actionFacade = new ActionFacade();
    private Gson gson = new Gson();
    
    public void registerClient(UUID uid, Client client) {
        synchronized (clients) {
            clients.put(uid, client);
            client.sendMessage(gson.toJson(getInitMessage()));
        }
    }
    
    public ClientData getInitMessage() {
        ClientData message = new ClientData();
        message.type = "system-startup-init";
        message.data = EndPointCollection.INSTANCE.getEndPoints();
        return message;
    }

    public void removeClient(UUID uid) {
        synchronized (clients) {
            clients.remove(uid);   
        }
    }
    
    public void receiveMessage(UUID uid, String message) {
        Action action = gson.fromJson(message, Action.class);
        actionFacade.handleAction(uid, action);
    }
    
    public void sendMessage(UUID uid, String message) {
        clients.get(uid).sendMessage(message);
    }
    
    public void sendMessage(String message) {
        for (Client client : clients.values()) {
            client.sendMessage(message);
        }
    }
}