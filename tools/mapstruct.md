## mapstruct 使用说明

MapStruct 可以将某几种类型的对象映射为另外一种类型，如将多个 DO 对象转换为 DTO。主要适用于**两个对象的大部分属性名称都相同**的场景。相比于Spring的BeanUtils.copyProperties()方法，还可以实现不同名称字段之间的属性赋值。

使用方式也很简单，定义一个映射接口，声明映射方法，配上注解，MapSturct 就会实现此接口

#### 基本使用，不同的名称字段可以通过@Mapping或者@Mappings来映射

```java
@Mapper
public interface CarMapper {
    // Car.make属性映射为CarDto.manufacturer，以此类推
    @Mappings({
        @Mapping(source = "make", target = "manufacturer"),
        @Mapping(source = "numberOfSeats", target = "seatCount")
    })
    CarDto carToCarDto(Car car);

    @Mapping(source = "name", target = "fullName")
    PersonDto personToPersonDto(Person person);
}
```

原理就是通过@Mapper注解的类会自动生成相应的实现类，根据方法上的注解生成对应的对象

#### 函数参数可以是多个对象，每个对象的一部分映射到返回的对象中

```java
@Mapper
public interface AddressMapper {

    @Mappings({
        @Mapping(source = "person.description", target = "description"),
        @Mapping(source = "address.houseNo", target = "houseNumber")
    })
    DeliveryAddressDto personAndAddressToDeliveryAddressDto(Person person, Address address);
}
```

> 注意：如果输入的多个对象有相同属性名的参数，且返回对象也刚好有相同属性名的参数，则必须指明哪个对象的相同属性名参数映射到返回对象中，否则会报错。

#### 上述都是映射成一个新对象，如果需要将某个已存在的对象映射到一个已存在的对象中，可以采用@MappingTarget注解实现。

```java
@Mapper
public interface CarMapper {
    void updateCarFromDto(CarDto carDto, @MappingTarget Car car);
}
```

#### mapstruct集成依赖注入

比如集成spring,可以通过如下方式集成: 

@Mapper(componentModel = "spring")

```java
@Mapper(componentModel = "spring")
public interface CarMapper {
    CarDto carToCarDto(Car car);
}
```

然后其他地方引用时，可以通过如下方式直接注入使用：

```java
@Autowired
private CarMapper carMapper;
```

#### 对象里面嵌套对象的属性也是可以指定映射的

```java
@Mapper
public interface FishTankMapperWithDocument {

    @Mappings({
        @Mapping(target = "fish.kind", source = "fish.type"),
        @Mapping(target = "quality.document", source = "quality.report")
    })
    FishTankWithNestedDocumentDto map( FishTank source );

}
```

#### 当某些属性名相同时，我们并不想自动映射，可以通过ignore来标志, 如下忽略type属性的映射

```java
@Mapper(componentModel = "spring")
public interface CarMapper {
    @Mappings({
            @Mapping(source = "manufacturer", target = "make"),
            @Mapping(source = "seatCount", target = "numberOfSeats"),
            @Mapping(target = "type",ignore = true)
    })
    void updateCarFromDto(CarDto carDto, @MappingTarget Car car);
}
```

#### Collection也是可以直接映射的

注意点：下面carListToCarDtoList会直接遍历List, 然后调用carToCarDto单个完成映射；如果没有carToCarDto函数则会自动生成一个，只不过不同属性的值无法映射

```java
@Mapper(componentModel = "spring")
public interface CarMapper {

    @Mappings({
            @Mapping(source = "make", target = "manufacturer"),
            @Mapping(source = "numberOfSeats", target = "seatCount")
    })
    CarDto carToCarDto(Car car);

    List<CarDto> carListToCarDtoList(List<Car> cars);
}
```