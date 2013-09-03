package org.anc.lapps.dsl

/**
 * @author Keith Suderman
 */
class ServerDelegate {
    String url
    String username
    String password

    def propertyMissing(String name, value) {
        throw new MissingPropertyException("Unknown property ${name}")
    }

    def propertyMissing(String name) {
        throw new MissingPropertyException("Unknown property ${name}")
    }
}
